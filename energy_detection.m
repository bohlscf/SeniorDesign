dig_signal = 1;
Pfa = 0.3;
N = 500;
snr_dB = -9;
disp(detection(dig_signal, Pfa, N, snr_dB));

function prob = detection(dig_signal, Pfa, N, snr_dB)
    % generate BPSK signal
    d= dig_signal;
    b=2*d-1; % Convert unipolar to bipolar
    T=1; % Bit duration
    Eb=T/2; % This will result in unit amplitude waveforms
    fc=3/T; % Carrier frequency
    t=linspace(0,5,N); % discrete time sequence between 0 and 5*T (500 samples)
    Nsb=N/length(d); % Number of samples per bit
    dd=repmat(d',1,Nsb); % replicate each bit Nsb times
    bb=repmat(b',1,Nsb); dw=dd'; % Transpose the rows and columns
    dw=dw(:)'; 
    % Convert dw to a column vector (colum by column) and convert to a row vector
    bw=bb';
    bw=bw(:)'; % Data sequence samples
    w=sqrt(2*Eb/T)*cos(2*pi*fc*t); % carrier waveform
    bpsk_w=bw.*w; % modulated waveform
    snr = 10.^(snr_dB./10);
    Pd = zeros(1,N);
 for m = 1: N
    num=0;
    for i = 1: N
         %-----AWGN noise with mean 0 and variance -----%
        noise = randn(1,N);
        v = var(noise);
        s = sqrt(snr)*bpsk_w;
        y = s + noise;
        energy = abs(y).^2;
        energy_fin =(1/N).*sum(energy);
        threshold(m) = (qfuncinv(Pfa)./sqrt(N/2))+v;
        if energy_fin >= threshold(m) % Check whether the received energy is greater than threshold, if so, increment Pd (Probability of detection) counter by 1
            num = num+1;
        end
    end
    Pd(1,m) = num/N;
 end 
    Pd = sum(Pd)/N;
    Pabs = 1 - Pfa;
    if dig_signal == 1
        prob = Pd;
    else
        prob = Pabs;
    end
    
    
  
    
end
