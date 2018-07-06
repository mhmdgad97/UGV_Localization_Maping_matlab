clear
clc
%User Defined Properties 
SerialPort='com6'; %serial port
s = serial(SerialPort);
set(s,'BaudRate',115200); % to be known from arduino
fopen(s);
plotTitle = 'Mine sweeper map';  % plot title
xLabel = 'X axcis';     % x-axis label
yLabel = 'Y axais';      % y-axis label
legend1 = 'Robot';
legend2 = 'Under Mine';
legend3 = 'Upper mine';

%%i cannot tell the difference
yMax  = 2000   ;                 %y Maximum Value (cm)
yMin  = 0       ;                %y minimum Value (cm)
plotGrid = 'on';                 % 'off' to turn off grid
min = 0;                         % set y-min (cm)
max = 2000;                      % set y-max (cm)
%%
delay = .01;      % make sure sample faster than resolution (connot understand what he means)
%Define Function Variables

time = 0;
data = 0;
data1 = 0;
data2 = 0;
count = 0;
recived =0;
%Set up Plot
robot = plot(time,data,'dr' )  % every AnalogRead needs to be on its own Plotgraph
hold on                            %hold on makes sure all of the channels are plotted
uppermines = plot(time,data1,'og')
lowermines = plot(time, data2,'+b' )

title(plotTitle,'FontSize',15);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
legend(legend1,legend2,legend3)
axis([yMin yMax min max]);

grid(plotGrid);
tic

while ishandle(robot) %Loop when Plot is Active will run until plot is closed (dont know the function use)
         
         recived=fscanf(s,'%s'); %%need to make sure that (%s) works correctly
         
         yangle=str2double(recieved(1:3));
         zangle=str2double(recieved(4:6));
         encoder=str2double(reciveed(7:9));
         minestate=str2double(recieved(10));
         
% dont know the importance of this chunk of code
%          dat = ; %Data from the arduino
%          dat1 = ; 
%          dat2 = ;       
%          count = count + 1;    
%          time(count) = toc;    
%          data(count) = dat(1);         
%          data1(count) = dat1(1)
%          data2(count) = dat2(1)

         %This is the magic code 
         %Using plot will slow down the sampling time.. At times to over 20
         %seconds per sample!
%----------------------------------------------------------------------
%to-do  the logic that will make sence of the data
% some values (like encoder) may need pre processing
    robXpos=cos(zangle)*encoder * cos(yangle);
    robYpos=cos(zangle)*encoder * sin(yangle);

    coilXpos=50;%the absolute postion of the coil relative to the centre of the robot
    coilYpos=50;
    
    switch minestate
        case 1 % the mine is up and on the right
            
            UmineXpos = robXpos + coilXpos;
            UmineYpos = robXpos - coilYpos;
            
      % break;
        
        case 2 %  the mine is up and on the left
            
            UmineXpos = robXpos - coilXpos;
            UmineYpos = robXpos - coilYpos;
            
      %  break;
        
        case 3 % the mine is down and on the right
            
             DmineXpos = robXpos + coilXpos;
             DmineYpos = robXpos - coilYpos;
            
      % break;
        
        case 4 % the mine is down and on the left
            
             DmineXpos = robXpos - coilXpos;
             DmineYpos = robXpos - coilYpos;
            
      % break;
    end

%----------------------------------------------------------------------
         set(robot,'XData',robXpos,'YData',robYpos);
         set(uppermines,'XData',UmineXpos,'YData',UmineYpos);
         set(lowermines,'XData',DmineXpos,'YData',DmineYpos);
          axis([0 time(count) min max]);
          %Update the graph
          pause(delay);
end
delete(a);
disp('Plot Closed and arduino object has been deleted');