function [] = homeRunsGraph()
close all;
global gui;
gui.fig = figure(); %makes a blank gui figure
gui.p = plot(0,0); %makes a blank plot that needs our input 
gui.p.Parent.Position = [0.2 0.25 0.7 0.7]; %parent position of the blank graph 
gui.buttonGroup = uibuttongroup('visible','on','unit','normalized','position',[0 0.4 0.15 0.25],'selectionchangedfcn',{@radioSelect}); %button box that will contain our uicontrol buttons. This box has its own system of coordinates toplace the uicontrol buttons in. Its callback is the @radioSelect
gui.r1 = uicontrol(gui.buttonGroup,'style','radiobutton','units','normalized','position',[0.1 0.8 1.0 0.2],'HandleVisibility','off','string','Both Leagues'); %button one shows the graph for both leagues
gui.r2 = uicontrol(gui.buttonGroup,'style','radiobutton','units','normalized','position',[0.1 0.5 1.0 0.2],'HandleVisibility','off','string','American League'); %button two shows the graph for the American League
gui.r3 = uicontrol(gui.buttonGroup,'style','radiobutton','units','normalized','position',[0.1 0.2 1.0 0.2],'HandleVisibility','off','string','National League'); %button three shows the graph for the National League
gui.scrollBar = uicontrol('style','slider','units','normalized','position',[0.2 0.1 0.6 0.05],'value',1901,'min',1901,'max',2010,'sliderstep',[1/117 1/117],'callback',{@scrollbar}); %the slider control that gets animated to move the graph from 1901 to to 2010 (further in the code we add 9 years)
%%%%%The slider step goes up by 1/117 in order to show the addition of every single year. Its call back is @scrollbar. We chose to do a slider because baseball players slide to the bases.
scrollbar(); %need to have this in order for the scroll bar to function
gui.animateButton = uicontrol('style','pushbutton','units','normalized','position',[0.05 0.85 0.1 0.1],'string','Let It Eat','callback',{@animate}); %this pushbutton gets the scroll bar to animate (move automatically) %the call back is @animate. 
%%%%%Our reference "Let It Eat" is a well known baseball slang term that can mean anything from OK to lets do this/give everything youve got. This played in well as the animate button because it starts the sliderbar.
end

function [] = animate(~,~) %callback for Let It Eat button
global gui; %access gui
    for i = 1901:2010 %values the scroll bar moves through (the last 9 years are added later on)
        gui.scrollBar.Value = i; %scrollbar vales
        scrollbar(); %need in order for the code to run
        pause(0.1); %how long the scroll bar pauses before scrolling to the next segment (year in our case)
    end
end

function [] = scrollbar(~,~) %callback to the slider
global gui; %access gui
gui.scrollBar.Value = round(gui.scrollBar.Value); %rounds the values of nonintegers to integers so nothing goes wrong with the values on the graph
type = gui.buttonGroup.SelectedObject.String; %makes sure only one button in the button group (button box) is working at a time. We only want the one that is selected to show up on the graph. 
plotSelectedYear(type); %plots on the graph whatever string is selected above (a string is selected by choosing a button in the button box ex. American League 
end

function [] = radioSelect(~,~) %callback to the button group (box)
global gui; %access gui
type = gui.buttonGroup.SelectedObject.String; %makes sure only one button in the button group (button box) is working at a time. We only want the one that is selected to show up on the graph.
plotSelectedYear(type);
end

function [] = plotSelectedYear(type)
global gui; %access gui
data = readmatrix('yearlyHomeRuns.xlsx'); %inputs our data into MATLAB. Our data came from the Baseball Almanac.

homeRunsAmericanLeague = data(:,1); %all of the first column is the American League
homeRunsNationalLeague = data(:,2); %all of the second column is the National League
homeRunsBothLeagues = data(:,3); %all of the thrid column is Both leagues together
yearListing = data(:,4); %all of the last column are the years we we pulled data from (1901-2019)

gui.scrollBar.Value = round(gui.scrollBar.Value); %rounds noninteger values to integers so that the code runs properly
currentYear = gui.scrollBar.Value; %the values that the scrollbar slides by are the current years

    if strcmp(type,'American League') %compares strings type and American League. Will return 0 if the two strings are identical otherwise a nonzero integer returns.
        yearlyHomeRuns = homeRunsAmericanLeague(yearListing == currentYear); %the values for the American homeruns are plotted against the current year
        for i = currentYear + 1:currentYear + 9 % shows 9 years on the graph at one time and after the animation the scroll bar increases one year
           yearlyHomeRuns = [yearlyHomeRuns homeRunsAmericanLeague(yearListing == currentYear)]; %finds the yearly home runs for the American league
        end
    elseif strcmp(type,'National League')%compares strings type and National League. Will return 0 if the two strings are identical otherwise a nonzero integer returns.
        yearlyHomeRuns = homeRunsNationalLeague(yearListing == currentYear); %the values for the National homeruns are plotted against the current year
        for i = currentYear + 1:currentYear + 9 % shows 9 years on the graph at one time and after the animation the scroll bar increases one year
           yearlyHomeRuns = [yearlyHomeRuns homeRunsNationalLeague(yearListing == currentYear)]; %finds the yearly home runs for the National league
        end
    elseif strcmp(type,'Both Leagues') %compares strings type and Both Leagues. Will return 0 if the two strings are identical otherwise a nonzero integer returns.
        yearlyHomeRuns = homeRunsBothLeagues(yearListing == currentYear); %the values for both League homeruns are plotted against the current year
        for i = currentYear + 1:currentYear + 9 % shows 9 years on the graph at one time and after the animation the scroll bar increases one year
           yearlyHomeRuns = [yearlyHomeRuns homeRunsBothLeagues(yearListing == currentYear)]; %finds the yearly home runs for both leagues
        end
    end
    
    gui.p = plot(currentYear:currentYear + 9,yearlyHomeRuns,'rx'); %plots the current year to the current year plus 9 years ex. 2000:2009
     hold off; %resets axes 
 title('Home Runs for the Year') %graph title
xlabel('Homeruns Per Year') %x axis label
ylabel('Year')% y axis label
    end