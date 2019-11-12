close all;
clear all;clc;

resource = ones(20,20,3);

%display distribution of all 4 users
% mu = mean; sigma = standard deviation

% User 1
mu1 = 8.3 + (1.2).*rand(1,1); 
sigma1 = 3 + (1.2).*rand(1,1);
x = 0:19;
y1 = normpdf(x,mu1,sigma1);
y1 = (.5/max(y1))*y1;
	
	% calculate confidence interval
	%{ std1 = sqrt(sigma1); low1 = floor((mu1-3.291*std1/sqrt(20)))-2; high1 = ceil(mu1+3.291*std1/sqrt(20))+2;
	%if low1 < 0    low1 =0;    end      interval1 = [low1 high1];
	%}

[low1 high1] = findInterval(mu1, 0.25, y1);
fprintf('The confidence interval 1 is: (%d, %d) \n', low1, high1);

%{
figure(1)
scatter(x,y1)
xlabel('Time Slot')
ylabel('Probability of appearing')
%}
%---------------------------------------------------------------------------
% User 2
mu2 = 5.5 + (1).*rand(1,1); 
sigma2 = 4 + (1).*rand(1,1);
y2 = normpdf(x,mu2,sigma2);
y2 = (.5/max(y2))*y2;

[low2 high2] = findInterval(mu2, 0.25, y2);
fprintf('The confidence interval 2 is: (%d, %d) \n', low2, high2);

%{
figure(2)
scatter(x,y2)
xlabel('Time Slot')
ylabel('Probability of appearing')
%}

%---------------------------------------------------------------------------
% User 3
mu3 = 13.5 + (1.2).*rand(1,1); 
sigma3 = 5 + (1.7).*rand(1,1);
y3 = normpdf(x,mu3,sigma3).*6;
y3 = (.5/max(y3))*y3;
	
[low3 high3] = findInterval(mu3, 0.25, y3);
fprintf('The confidence interval 3 is: (%d, %d) \n', low3, high3);

%{
figure(3)
scatter(x,y3)
xlabel('Time Slot')
ylabel('Probability of appearing')
%}
%---------------------------------------------------------------------------
% User 4
mu4 = 6.9 + (0.5).*rand(1,1); 
sigma4 = 2 + (1.2).*rand(1,1);
y4 = normpdf(x,mu4,sigma4).*6;
y4 = (.5/max(y4))*y4;

[low4 high4] = findInterval(mu4, 0.25, y4);
fprintf('The confidence interval 4 is: (%d, %d) \n', low4, high4);

%{
figure(4)
scatter(x,y4)
xlabel('Time Slot')
ylabel('Probability of appearing')
%}
%---------------------------------------------------------------------------
actualPuLocation = zeros(4,20);
su = zeros(4,20);
energyDetectedBySU = zeros(4,20);
energyDetectionAccuracy = zeros(4,20);
probabilityOfNoPU = 1-[y4;y3;y2;y1];
freqBlockSU1 = 1;			% j will be changed to change the frequency block of the SU
rowOfSU1 = 5-freqBlockSU1;

for i = 1:20
    % assign randomly, user 4 is using first block, user3 uses second block,
    % user 2 uses third block, user 1 uses last block.
    
    threshold  = 0.4;
    func = 0.25*(y1(i) + y2(i) + y3(i) + y4(i));
    if func<0.2
        su(rowOfSU1,i) = 1;
    end
    
  %each time slot

  %block 1
    prob1 = rand;
    if prob1 <= y4(i)
        actualPuLocation(1,i) = 1;
    else
        actualPuLocation(1,i) = 0;
    end

  %block 2
    prob2 = rand;
    if prob2 <= y3(i)
        actualPuLocation(2,i) = 1;
    else
        actualPuLocation(2,i) = 0;
    end

  %block 3
    prob3 = rand;
    if prob3 <= y2(i)
        actualPuLocation(3,i) = 1;
    else
        actualPuLocation(3,i) = 0;
    end

  %block 4
    prob4 = rand;
    if prob4 <= y1(i)
        actualPuLocation(4,i) = 1;
    else
        actualPuLocation(4,i) = 0;
    end

   %giving values for the 'plotting'
    if actualPuLocation(4,i) == 1 && su(rowOfSU1,i) == 1
        disp("Interfere"); 
        resource(1:5, i,1) = 0;
    elseif actualPuLocation(4,i) == 0 && su(rowOfSU1,i) == 1
        resource(1:5, i,2) = 0;
    elseif actualPuLocation(4,i) == 1
        resource(1:5, i,1) = 0;
    end

    if actualPuLocation(3,i) == 1
        resource(5:10, i,1) = 0;
    end

    if actualPuLocation(2,i) == 1
        resource(10:15, i,1) = 0;
    end


    if actualPuLocation(1,i) == 1
        resource(15:20, i,1) = 0;
    end
    
%%%Place this inside of a function for energyDetection
    
    for k = 1:4
%THIS WILL BE REPLACED BY A MORE ADVANCED ENERGY DETECTION METHOD
	energyDetectionAccuracy(k,i) = randi(10,1,1);	%randi(IMAX,M,N) M-by-N matrix
	if energyDetectionAccuracy(k,i) <= 8
	    energyDetectedBySU(k,i) = actualPuLocation(k,i);
    	else
	    energyDetectedBySU(k,i) = (actualPuLocation(k,i)*-1)+1;	%This changes a 1->0 and a 0->1
	end
	
	if energyDetectedBySU(k,i) == 1
	    energyDetectedBySU(k,i) = 0.2;	% 20 percent chance the PU is NOT there
    	elseif energyDetectedBySU(k,i) == 0
	    energyDetectedBySU(k,i) = 0.8;	% 80 percent chance the PU is NOT there
	end
	
	energyAndProbability(k,i) = (2*energyDetectedBySU(k,i) + probabilityOfNoPU(k,i))/3;
    end

    
    figure(5)
    image(resource)
    xlabel('Time slot')
    ylabel('Frequency (MHz)')
    set(gca,'YDir','normal')
    %pause
end

energyAndProbability