close all;
clear all;

resource = ones(720,20,3);

%display distribution of all 4 users
% User 1
mu1 = 8.3 + (1.2).*rand(1,1); 
sigma1 = 3+(1.2).*rand(1,1);
x = 0:19;
y1 = normpdf(x,mu1,sigma1);
y1 = (.5/max(y1))*y1;
% calculate confidence interval
%{
std1 = sqrt(sigma1);
low1 = floor((mu1-3.291*std1/sqrt(20)))-2;
high1 = ceil(mu1+3.291*std1/sqrt(20))+2;
if low1 < 0
    low1 =0;
end
interval1 = [low1 high1];
%}
[low1 high1] = findInterval(mu1, 0.25, y1);
fprintf('The confidence interval 1 is: (%d, %d) \n', low1, high1);
figure(1)
scatter(x,y1)
xlabel('Time Slot')
ylabel('Probability of appearing')

% User 2
mu2 = 5.5 + (1).*rand(1,1); 
sigma2 = 4 + (1).*rand(1,1);
y2 = normpdf(x,mu2,sigma2);
y2 = (.5/max(y2))*y2;
% calculate confidence interval
%{
std2 = sqrt(sigma2);
low2 = floor(mu2-3.291*std2/sqrt(20))-2;
high2 = ceil(mu2+3.291*std2/sqrt(20))+2;
if low2 < 0
    low2 =0;
end
interval2 = [low2 high2];
%}
[low2 high2] = findInterval(mu2, 0.25, y2);
fprintf('The confidence interval 2 is: (%d, %d) \n', low2, high2);

figure(2)
scatter(x,y2)
xlabel('Time Slot')
ylabel('Probability of appearing')

% User 3
mu3 = 13.5 + (1.2).*rand(1,1); 
sigma3 = 5 + (1.7).*rand(1,1);
y3 = normpdf(x,mu3,sigma3).*6;
y3 = (.5/max(y3))*y3;
% calculate confidence interval
%{
std3 = sqrt(sigma3);
low3 = floor(mu3-3.291*std3/sqrt(20))-2;
high3 = ceil(mu3+3.291*std3/sqrt(20))+2;
if low3 < 0
    low3 =0;
end
interval3 = [low3 high3];
%}
[low3 high3] = findInterval(mu3, 0.25, y3);
fprintf('The confidence interval 3 is: (%d, %d) \n', low3, high3);

figure(3)
scatter(x,y3)
xlabel('Time Slot')
ylabel('Probability of appearing')

% User 4
mu4 = 6.9 + (0.5).*rand(1,1); 
sigma4 = 2 + (1.2).*rand(1,1);
y4 = normpdf(x,mu4,sigma4).*6;
y4 = (.5/max(y4))*y4;
% calculate confidence interval
%{
std4 = sqrt(sigma4);
low4 = floor(mu4-3.291*std4/sqrt(20))-2;
high4 = ceil(mu4+3.291*std4/sqrt(20))+2;
if low4 < 0
    low4 =0;
end
interval4 = [low4 high4];
%}
[low4 high4] = findInterval(mu4, 0.25, y4);
fprintf('The confidence interval 4 is: (%d, %d) \n', low4, high4);

figure(4)
scatter(x,y4)
xlabel('Time Slot')
ylabel('Probability of appearing')

present = zeros(20,4);
su = zeros(4,20);
j = 1;

for i = 1:20
    % assign randomly user 4 is using first block, user3 uses second block,
    % user 2 uses third block, user 1 uses last block.
    
    threshold  = 0.4;
    func = 0.25*(y1(i) + y2(i)+y3(i)+y4(i));
    if func<0.2
        su(j,i) = 1;
    end
    
    % time slot 1

    %block 1
    prob1 = rand;
    if prob1 <= y4(i)
        present(i,1) = 1;
    else
        present(i,1) = 0;
    end

    %block 2
    prob2 = rand;
    if prob2 <= y3(i)
        present(i,2) = 1;
    else
        present(i,2) = 0;
    end

    %block 3
    prob3 = rand;
    if prob3 <= y2(i)
        present(i,3) = 1;
    else
        present(i,3) = 0;
    end

    %block 4
    prob4 = rand;
    if prob4 <= y1(i)
        present(i,4) = 1;
    else
        present(i,4) = 0;
    end

    if present(i,1) == 1 && su(1,i) == 1
        disp("Interfere");
        resource(1:180, i,3) = 0;
    elseif present(i,1) == 0 && su(1,i) == 1
        resource(1:180, i,2) = 0;
    elseif present(i,1) == 1
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
    
    
    figure(5)
    image(resource)
    xlabel('Time slot')
    ylabel('Frequency')
    set(gca,'YDir','normal')
    pause
end
 
function [low, high] = findInterval(mean, threshold, user)
    middle = floor(mean);
    low = 0;
    k = size(user);
    high = k(2);
    for i = middle:-1:1
        if user(i) <= threshold
            low = i;
            break;
        end
    end
    
    for j = middle:k(2)
        if user(j) <= threshold
            high = j;
            break;
        end
    end
end
