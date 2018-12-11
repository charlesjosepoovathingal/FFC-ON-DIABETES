function fig = buildProcessingManager()
%
% Builder for the ProcessingManager View
%

% import tree package
import uiextras.jTree.*

% Make the figure
fig = figure('Name','Processing Manager','NumberTitle','off',...
    'MenuBar','none','ToolBar','none','Units','normalized',...
    'Position',[0.35 0.15 0.30 0.45],'Tag','fig','Visible','off');

% Add grid & box for panels
grid = uix.Grid( 'Parent', fig, 'Spacing', 0); 
box = uix.VBox( 'Parent', grid,'Padding',5,'Spacing',4, 'Tag', 'box');

% Add processing mode panel, file selection panel & process selection panel
mode_panel = uix.Panel( 'Parent', box,...
                        'Title', 'Processing Mode',...
                        'Padding',2);
process_panel = uix.Panel( 'Parent', box,...
                           'Title', 'Process settings',...
                           'Padding',2);

% Add RunButton
buttonbox = uix.HButtonBox( 'Parent', box,...
                            'Spacing', 15,...
                            'HorizontalAlignment','center',...
                            'ButtonSize', [200 40] ); 
                        
uicontrol( 'Parent', buttonbox,...
            'Style','pushbutton',...
            'String','Run Process',...
            'Tag','RunPushButton'); 
                        
% Mode Panel
% + Radio button
buttonbox = uix.HButtonBox( 'Parent', mode_panel,...
                            'Spacing', 15,...
                            'HorizontalAlignment','center',...
                            'ButtonSize', [100 20] ); 
                        
uicontrol( 'Parent', buttonbox,...
            'Style','radiobutton',...
            'Value',1,...
            'String','Batch',...
            'Tag','BatchRadioButton');
uicontrol( 'Parent', buttonbox,...
            'Style','radiobutton',...
            'Value',0,...
            'String','Simulation',...
            'Tag','SimulationRadioButton');
% Process Panel
% + Grid, VBox
grid_process = uix.Grid( 'Parent', process_panel, 'Spacing', 0 ); 
box_process = uix.VBox( 'Parent', grid_process,'Padding',2,'Spacing',2,...
                        'Tag', 'box_process');



% + TabGroup
uitabgroup(box_process,'Position',[0 0 1 1],'Tag','tab');

% set heights    
box.Heights = [-1.5 -8 -1];
end

