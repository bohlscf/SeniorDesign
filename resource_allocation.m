close all;
clear all;

resource = ones(720,20,3);
figure(1)
image(resource)
xlabel('Time slot')
ylabel('Frequency')
set(gca,'YDir','normal')


%display distribution of all 4 users
% User 1
mu1 = 9; 
sigma1 = 4;
x = 0:19;
y1 = normpdf(x,mu1,sigma1);
y1 = (.8/max(y1))*y1;
figure(2)
scatter(x,y1)
xlabel('Time Slot')
ylabel('Probability of appearing')

% User 2
mu2 = 6; 
sigma2 = 5;
y2 = normpdf(x,mu2,sigma2);
y2 = (.8/max(y2))*y2;
figure(3)
scatter(x,y2)
xlabel('Time Slot')
ylabel('Probability of appearing')

% User 3
mu3 = 14; 
sigma3 = 3;
y3 = normpdf(x,mu3,sigma3).*6;
y3 = (.8/max(y3))*y3;
figure(4)
scatter(x,y3)
xlabel('Time Slot')
ylabel('Probability of appearing')

% User 4
mu4 = 7; 
sigma4 = 2;
y4 = normpdf(x,mu4,sigma4).*6;
y4 = (.8/max(y4))*y4;
figure(5)
scatter(x,y4)
xlabel('Time Slot')
ylabel('Probability of appearing')

present = zeros(20,4);
su = zeros(4,20);
for i = 1:20
    % assign randomly user 4 is using first block, user3 uses second block,
    % user 2 uses third block, user 1 uses last block.
    
    % time slot 1

    %block 1
    prob1 = rand;
    if rand <= y4(i)
        present(i,1) = 1;
    else
        present(i,1) = 0;
    end

    %block 2
    prob2 = rand;
    if rand <= y3(i)
        present(i,2) = 1;
    else
        present(i,2) = 0;
    end

    %block 3
    prob3 = rand;
    if rand <= y2(i)
        present(i,3) = 1;
    else
        present(i,3) = 0;
    end

    %block 4
    prob4 = rand;
    if rand <= y1(i)
        present(i,4) = 1;
    else
        present(i,4) = 0;
    end

    if present(i,1) == 1
        resource(1:180, i,3) = 0;
    end

    if present(i,2) == 1
        resource(180:360, i,3) = 0;
    end

    if present(i,3) == 1
        resource(360:540, i,3) = 0;
    end


    if present(i,4) == 1
        resource(540:720, i,3) = 0;
    end
    
    figure(6)
    image(resource)
    xlabel('Time slot')
    ylabel('Frequency')
    set(gca,'YDir','normal')
    pause
end
 
