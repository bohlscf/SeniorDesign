dig_signal = 0;
Pfa = 0.3;
N = 500;
[guess, prob] = detection(dig_signal, Pfa, N);
fprintf('Guess is %d\n', guess)
fprintf('Level of confidence is %.2f', prob)

function [guess,prob] = detection(dig_signal, Pfa, N)
    fc = 1e6;
    t=linspace(0,5,N);
    if dig_signal == 1
        s = (1/2)*sin(1e6*2*pi*t);
    else
        s = 0;
    end
    Pd = zeros(1,N);
    Pabs = zeros(1,N);
    guess1 = zeros(1,N);
    guess0 = zeros(1,N);
 for m = 1: N
    numd=0;
    numabs = 0;
    for i = 1: N
         %-----AWGN noise with mean 0 and variance -----%
        noise = randn(1,N);
        y = s + noise;
        energy = abs(y).^2;
        energy_fin =(1/N).*sum(energy);
        threshold(m) = (qfuncinv(Pfa)./sqrt(N/2))+1;
        if energy_fin >= threshold(m)   % Check whether the received energy is greater than threshold, if so, increment Pd (Probability of detection) counter by 1
           guess1(1,m) = guess1(1,m)+1;
            if dig_signal == 1 
                numd = numd+1;
            end
        end
        if energy_fin < threshold(m) 
            guess0(1,m) = guess0(1,m)+1;
            if dig_signal == 0
                numabs = numabs+1;
            end
        end
    end
    Pd(1,m) = numd/N;
    Pabs(1,m) = numabs/N;
 end 
    Pd = sum(Pd)/N;
    Pabs = sum(Pabs)/N;
    guess1 = sum(guess1)/N;
    guess0 = sum(guess0)/N;
    if guess1 > guess0
        guess = 1;
        prob = Pd;
    else
        guess =0;
        prob = Pabs;
    end
    
  
    
end
