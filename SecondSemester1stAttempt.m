close all;
clear all;clc;

% Initializing main variables

% # of transmit time blocks for PUs
transmit1 = randi([0 1]); % 1 = transmitted, 0 = silence
transmit2 = randi([0 1]);
transmit3 = randi([0 1]);
transmit4 = randi([0 1]);
% # of silence time blocks for PUs
silence1 = ~ transmit1;  % 0 = transmitted, 1 = silence
silence2 = ~ transmit2;
silence3 = ~ transmit3;
silence4 = ~ transmit4;

maxTimeSlots = 50;                        % the total number of time slots that will take place
resource = ones(20,maxTimeSlots,3);       % used to produce final time vs frequency image
actualPuLocation = zeros(4,maxTimeSlots); % matrix showing the 4 PUs transmission history (1 = transmit)
su = zeros(4,maxTimeSlots);               % matrix showing the SU's transmission history (1 = transmit)

%----------------------------------------------------------------------

% Computation of PU & SU location
% First, determining PU
for i = 1:maxTimeSlots
    %each value of i represents a time slot
    % user 1 is using first(top) block, user 2 uses second block,
    % user 3 uses third block, user 4 uses last(bottom) block.

  %block 1 (top block)
    if transmit1 > 0                    %PU1 will transmit here
        actualPuLocation(1,i) = 1;
        transmit1 = transmit1 - 1;
    elseif silence1 > 0
        actualPuLocation(1,i) = 0;      %PU1 is silent here
        silence1 = silence1 - 1;
        if silence1 == 0
            transmit1 = randi([2 5]);   %PU1 will transmit next time slot (according to its distribution)
        end
    end
    if silence1 == 0 & transmit1 == 0
        silence1 = randi([1 4]);        %PU1 will be silent next time slot (according to its distribution)
    end
    
    
    %block 2 
    if transmit2 > 0                    %PU2 will transmit here
        actualPuLocation(2,i) = 1;
        transmit2 = transmit2 - 1;
    elseif silence2 > 0
        actualPuLocation(2,i) = 0;      %PU2 is silent here
        silence2 = silence2 - 1;
        if silence2 == 0
            transmit2 = randi([1 8]);   %PU2 will transmit next time slot (according to its distribution)
        end
    end
    if silence2 == 0 & transmit2 == 0
        silence2 = randi([1 7]);        %PU2 will be silent next time slot (according to its distribution)
    end
    
    
     %block 3
    if transmit3 > 0                    %PU3 will transmit here
        actualPuLocation(3,i) = 1;
        transmit3 = transmit3 - 1;
    elseif silence3 > 0
        actualPuLocation(3,i) = 0;      %PU3 is silent here
        silence3 = silence3 - 1;
        if silence3 == 0
            transmit3 = randi([4 6]);   %PU3 will transmit next time slot (according to its distribution)
        end
    end
    if silence3 == 0 & transmit3 == 0
        silence3 = randi([3 6]);        %PU3 will be silent next time slot (according to its distribution)
    end
    
    
    %block 4 (bottom block)
    if transmit4 > 0                    %PU4 will transmit here
        actualPuLocation(4,i) = 1;
        transmit4 = transmit4 - 1;
    elseif silence4 > 0
        actualPuLocation(4,i) = 0;      %PU4 is silent here
        silence4 = silence4 - 1;
        if silence4 == 0
            transmit4 = randi([2 6]);   %PU4 will transmit next time slot (according to its distribution)
        end
    end
    if silence4 == 0 & transmit4 == 0
        silence4 = randi([1 5]);        %PU4 will be silent next time slot (according to its distribution)
    end
    
% Next, determining the SU tranmitting location
    
% THIS WILL BE DNN LOCATION
% rowOfSU1 = 1;		% top/1st resource block
% --DNN--
% su(rowOfSU1,i) = 1; 	%giving value to SU


%------------------------------------------------------------------------

% Giving values for the 'plotting'

    % PU4 and SU
    if actualPuLocation(4,i) == 1 && su(4,i) == 1
        disp("Interference in 4th resource block"); 
        resource(1:5, i,1) = 0;
        su(4,i) = 0;
    elseif actualPuLocation(4,i) == 0 && su(4,i) == 1
        resource(1:5, i,2) = 0;
    elseif actualPuLocation(4,i) == 1
        resource(1:5, i,1) = 0;
    end

    % PU3 and SU
    if actualPuLocation(3,i) == 1 && su(3,i) == 1
        disp("Interference in 3rd resource block"); 
        resource(6:9, i,1) = 0;
        su(3,i) = 0;
    elseif actualPuLocation(3,i) == 0 && su(3,i) == 1
        resource(6:9, i,2) = 0;
    elseif actualPuLocation(3,i) == 1
        resource(6:9, i,1) = 0;
    end

    % PU2 and SU
    if actualPuLocation(2,i) == 1 && su(2,i) == 1
        disp("Interference in 2nd resource block"); 
        resource(10:15, i,1) = 0;
        su(2,i) = 0;
    elseif actualPuLocation(2,i) == 0 && su(2,i) == 1
        resource(10:15, i,2) = 0;
    elseif actualPuLocation(2,i) == 1
        resource(10:15, i,1) = 0;
    end

    %PU1 and SU
    if actualPuLocation(1,i) == 1 && su(1,i) == 1
        disp("Interference in 1st resource block"); 
        resource(16:19, i,1) = 0;
        su(1,i) = 0;
    elseif actualPuLocation(1,i) == 0 && su(1,i) == 1
        resource(16:19, i,2) = 0;
    elseif actualPuLocation(1,i) == 1
        resource(16:19, i,1) = 0;
    end
    
    % Creating a time vs frequency plot for our spectrum
    figure(5)
    image(resource)
    xlabel('Time slot')
    ylabel('Frequency (GHz)')
    title('Blue - Primary Users, Purple - Secondary Users');
    set(gca,'YDir','normal')
    %pause
    
    
end
