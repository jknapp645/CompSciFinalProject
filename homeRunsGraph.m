function [] = homeRunsGraph()
close all;
global gui;
gui.fig = figure(); %opens a figure
gui.p = plot(0,0); %plots a graph without input
gui.p.Parent.Position = [0.1 0.25 0.7 0.7]; %postion of graph
gui.buttonGroup = uibuttongroup('visible','on','unit','normalized','position',[0.85 0.4 0.15 0.25],'selectionchangedfcn',{@radioSelect});
gui.r1 = uicontrol(gui.buttonGroup,'style','radiobutton','units','normalized','position',[0.1 0.8 1.0 0.2],'HandleVisibility','off','string','Both Leagues');
gui.r2 = uicontrol(gui.buttonGroup,'style','radiobutton','units','normalized','position',[0.1 0.5 1.0 0.2],'HandleVisibility','off','string','American League');
gui.r3 = uicontrol(gui.buttonGroup,'style','radiobutton','units','normalized','position',[0.1 0.2 1.0 0.2],'HandleVisibility','off','string','National League');
gui.scrollBar = uicontrol('style','slider','units','normalized','position',[0.2 0.1 0.6 0.05],'value',1901,'min',1901,'max',2019,'sliderstep',[1/59 1/59],'callback',{@scrollbar});
scrollbar();
gui.animateButton = uicontrol('style','pushbutton','units','normalized','position',[0.85 0.85 0.1 0.1],'string','Let It Eat','callback',{@animate});
end

function [] = animate(~,~)
global gui;
    for i = 1901:2019
        gui.scrollBar.Value = i;
        scrollbar();
        pause(0.3);
    end      
end


function [] = scrollbar(~,~)
global gui;
gui.scrollBar.Value = round(gui.scrollBar.Value);
type = gui.buttonGroup.SelectedObject.String;
plotSelectedYear(type);
end

function [] = radioSelect(~,~)
global gui;
type = gui.buttonGroup.SelectedObject.String;
plotSelectedYear(type);
end

function [] = plotSelectedYear(type)
global gui;
data = readmatrix('yearlyHomeRuns.xlsx');

homeRunsAmericanLeague = data(:,1);
homeRunsNationalLeague = data(:,2);
homeRunsBothLeagues = data(:,3);
yearListing = data(:,4);

gui.scrollBar.Value = round(gui.scrollBar.Value);
currentYear = gui.scrollBar.Value;

yearlyHomeRuns = homeRunsBothLeagues(yearListing == currentYear);
    if strcmp(type,'American League')
        yearlyHomeRuns = homeRunsAmericanLeague;
    elseif strcmp(type,'National League')
        yearlyHomeRuns = homeRunsNationalLeague;
    elseif strcmp(type,'Both Leagues')
        yearlyHomeRuns = homeRunsBothLeagues;
    end
    

    gui.p = plot(1901:2019,yearlyHomeRuns,'rx');
 title('Home Runs for the Year') %graph title
xlabel('Homeruns Per Year') %x axis label
ylabel('Year')% y axis label
end
