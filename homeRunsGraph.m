function [] = homeRunsGraph()
close all;
global gui; %access gui
gui.fig = figure(); %opens a gui figure
gui.p = plot(0,0); %plots a graph without input
gui.p.Parent.Position = [0.1 0.25 0.7 0.7]; %postion of graph on gui
gui.buttonGroup = uibuttongroup('visible','on','unit','normalized','position',[0.85 0.4 0.15 0.25],'selectionchangedfcn',{@radioSelect}); %set place to put all the buttons in 
gui.r1 = uicontrol(gui.buttonGroup,'style','radiobutton','units','normalized','position',[0.1 0.8 1.0 0.2],'HandleVisibility','off','string','Both Leagues'); %button 1 shows both league homeruns
gui.r2 = uicontrol(gui.buttonGroup,'style','radiobutton','units','normalized','position',[0.1 0.5 1.0 0.2],'HandleVisibility','off','string','American League'); %button 2 shows american league homerus
gui.r3 = uicontrol(gui.buttonGroup,'style','radiobutton','units','normalized','position',[0.1 0.2 1.0 0.2],'HandleVisibility','off','string','National League'); %button 3 shows national league homeruns
gui.scrollBar = uicontrol('style','slider','units','normalized','position',[0.2 0.1 0.6 0.05],'value',1901,'min',1901,'max',2019,'sliderstep',[1/59 1/59],'callback',{@scrollbar}); %scrollbar 
scrollbar();
gui.animateButton = uicontrol('style','pushbutton','units','normalized','position',[0.85 0.85 0.1 0.1],'string','Let It Eat','callback',{@animate}); %animates the scroll bar... Let it eat is a well known baseball term
end

function [] = animate(~,~) %callback to tell what to animate
global gui; %access gui
    for i = 1901:2019 %values that the scrollbar rolls through
        gui.scrollBar.Value = i;
        scrollbar();
        pause(0.3); %how long the scrollbar waits to scroll further
    end      
end


function [] = scrollbar(~,~) %callback to run scrollbar
global gui; %access gui
gui.scrollBar.Value = round(gui.scrollBar.Value); %round the scrollbar values
type = gui.buttonGroup.SelectedObject.String;
plotSelectedYear(type); %plot the selected year (which is all 118 of them)
end

function [] = radioSelect(~,~) %callback to access buttons inside the parent 
global gui; %access gui
type = gui.buttonGroup.SelectedObject.String;
plotSelectedYear(type);
end

function [] = plotSelectedYear(type) %all the data going onto the graph and buttons
global gui; %access gui
data = readmatrix('yearlyHomeRuns.xlsx'); %reads data 

homeRunsAmericanLeague = data(:,1); %corresponding column data - all of column 1
homeRunsNationalLeague = data(:,2); %%%% all of column 2
homeRunsBothLeagues = data(:,3); %%%% all of column 3 
yearListing = data(:,4); %%%% all of column 4

gui.scrollBar.Value = round(gui.scrollBar.Value);
currentYear = gui.scrollBar.Value;

yearlyHomeRuns = homeRunsBothLeagues(yearListing == currentYear);
    if strcmp(type,'American League')%comparing using an if statement
        yearlyHomeRuns = homeRunsAmericanLeague; %what part of the data shows American League homeruns
    elseif strcmp(type,'National League')%comparing
        yearlyHomeRuns = homeRunsNationalLeague;%what part of the data shows National League homeruns
    elseif strcmp(type,'Both Leagues') %comparing
        yearlyHomeRuns = homeRunsBothLeagues; %what part of the data shows Both League homeruns
    end
    

    gui.p = plot(1901:2019,yearlyHomeRuns,'rx'); %plots the data in a gui
        title('Home Runs for the Year') %graph title
        xlabel('Homeruns Per Year') %x axis label
        ylabel('Year')% y axis label
end
