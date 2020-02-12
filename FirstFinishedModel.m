close all;
clear all;clc;
% **NOTE: To change the number of time slots change variable - "maxTimeSlots"

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

% change "maxTimeSlots" to change the total number of time slots
maxTimeSlots = 100000;                        % the total number of time slots that will take place
resource = ones(20,maxTimeSlots,3);       % used to produce final time vs frequency image
actualPuLocation = zeros(4,maxTimeSlots); % matrix showing the 4 PUs transmission history (1 = transmit)
su = zeros(4,maxTimeSlots);               % matrix showing the SU's transmission history (1 = transmit)
bestSuDecision = zeros(1, maxTimeSlots);  % matrix showing what decision the SU should make (1 = top freq block; 4 = bottom)

% -------------------------------------------------------------------------------------------------
% Graphing of the transmission and silence distributions for PUs 1,2,3,4
%{
% Transmission Graph for PU 1
 figure(1);
 scatter([ 2 3 4 5 ], [ .25 .25 .25 .25 ]);
 xlabel('Number of Time Slots to Transmit')
 ylabel('Probability')
 title('Primary User 1 Transmission Distribution');
 grid on;
 axis([0 10 0 .5]);
 
 % Silence Graph for PU 1
 figure(5);
 scatter([ 1 2 3 4 ], [ .25 .25 .25 .25 ]);
 xlabel('Number of Time Slots for Silence')
 ylabel('Probability')
 title('Primary User 1 Silence Distribution');
 grid on;
 axis([0 10 0 .5]);
 
 % Transmission Graph for PU 2
 figure(2);
 scatter([ 1 2 3 4 5 6 7 8 ], [.125 .125 .125 .125 .125 .125 .125 .125 ]);
 xlabel('Number of Time Slots to Transmit')
 ylabel('Probability')
 title('Primary User 2 Transmission Distribution');
 grid on;
 axis([0 10 0 .5]);
 
% Silence Graph for PU 2
 figure(6);
 scatter([ 1 2 3 4 5 6 7 ], [ .14 .14 .14 .14 .14 .14 .14 ]);
 xlabel('Number of Time Slots for Silence')
 ylabel('Probability')
 title('Primary User 2 Silence Distribution');
 grid on;
 axis([0 10 0 .5]);
 
 
 % Transmission Graph for PU 3
 figure(3);
 scatter([ 4 5 6 ], [ .33 .33 .33 ]);
 xlabel('Number of Time Slots to Transmit')
 ylabel('Probability')
 title('Primary User 3 Transmission Distribution');
 grid on;
 axis([0 10 0 .5]);
 
% Silence Graph for PU 3
 figure(7);
 scatter([ 3 4 5 6 ], [ .25 .25 .25 .25 ]);
 xlabel('Number of Time Slots for Silence')
 ylabel('Probability')
 title('Primary User 3 Silence Distribution');
 grid on;
 axis([0 10 0 .5]);

 % Transmission Graph for PU 4
 figure(4);
 scatter([ 2 3 4 5 6 ], [ .2 .2 .2 .2 .2 ]);
 xlabel('Number of Time Slots to Transmit')
 ylabel('Probability')
 title('Primary User 4 Transmission Distribution');
 grid on;
 axis([0 10 0 .5]);

% Silence Graph for PU 4
 figure(8);
 scatter([ 1 2 3 4 5 ], [ .2 .2 .2 .2 .2 ]);
 xlabel('Number of Time Slots for Silence')
 ylabel('Probability')
 title('Primary User 4 Silence Distribution');
 grid on;
 axis([0 10 0 .5]);
%}
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
    %{
    % Creating a time vs frequency plot for our spectrum
    figure(9)
    image(resource)
    xlabel('Time slot')
    ylabel('Frequency (GHz)')
    title('Blue - Primary Users, Purple - Secondary Users');
    set(gca,'YDir','normal')
    %pause
    %}
    
end

% --------------------------------------------------------------------------------
% Next, determining the SU's best transmitting location
 timeSlotVector = zeros(1,maxTimeSlots); %Vector to keep track of the number of time slots
 
for i = 1:maxTimeSlots
    timeSlot = i;        % This is needed to count the future time slots open
    maxOpenings = 0;
    bestFreqBlock = 0;
    
    for j = 1:4                 % This will cycle through all the frequency blocks
        timeSlot = i;
        openingsCounter = 0;    % This counts the current time slot openings for a freq block to compare against the maxOpenings
        % This counts up how many consecutive time slots are open per frequency block
        while  timeSlot <= maxTimeSlots && actualPuLocation(j,timeSlot) == 0    
           openingsCounter = openingsCounter+1;
           if openingsCounter > maxOpenings
               maxOpenings = openingsCounter;
               bestFreqBlock = j;
           end
               timeSlot = timeSlot+1;
           
       end
    end
    bestSuDecision(1,i) = bestFreqBlock;
    timeSlotVector(1,i) = i;
end

finalInputData = [actualPuLocation' timeSlotVector'];

csvwrite('outputFile2.csv',bestSuDecision');
csvwrite('inputFile2.csv',finalInputData);