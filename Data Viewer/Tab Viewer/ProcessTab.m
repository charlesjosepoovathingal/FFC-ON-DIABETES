classdef ProcessTab < uix.Container & handle
    %
    % Class that define custom tab for ProcessingManager (Process settings)
    %
    
    properties (Access = public)
        FitLike % handle to Presenter
        hbox % main horizontal box
        vbox % array of vertical box
        TabTitle % tab title        
        ProcessArray % list of the process
    end
    
    properties (Access = public)
       ArrowIconUp % arrow up
       ArrowIconDown %arrow down
       DeleteIcon %delete 
    end
    
    methods
        % Constructor
        function this = ProcessTab(FitLike, tab, TabTitle)
            % Call superclass constructor
            this@uix.Container();
            % set Presenter & Title
            this.FitLike = FitLike;
            this.TabTitle = TabTitle;
            % Create the grid in the parent tab
            grid = uix.Grid('Parent',this,'Spacing', 2); 
            % set the Parent 
            this.Parent = tab;
            this.Parent.Title = this.TabTitle;            
            %---------------------------BUILDER---------------------------%
            % create main horyzontal box
            this.hbox = uix.HBox( 'Parent', grid, 'Padding', 2);
            % create vertical boxes (fonction name, input type, output
            % type, parameter, remove option)
            this.vbox{1} = uix.VButtonBox( 'Parent', this.hbox,...
                'VerticalAlignment','top','Padding', 2,...
                'ButtonSize',[150 22]);
            this.vbox{2} = uix.VButtonBox( 'Parent', this.hbox,...
                'VerticalAlignment','top','Padding', 2,...
                'ButtonSize',[150 22]);
            this.vbox{3} = uix.VButtonBox( 'Parent', this.hbox,...
                'VerticalAlignment','top','Padding', 2,...
                'ButtonSize',[150 22]);
            this.vbox{4} = uix.VButtonBox( 'Parent', this.hbox,...
                'VerticalAlignment','top','Padding', 2,...
                'ButtonSize',[150 22]);
            this.vbox{5} = uix.VButtonBox( 'Parent', this.hbox,...
                'VerticalAlignment','top','Padding', 2,...
                'ButtonSize',[150 22]);
            
            % create titles for the boxes
            uicontrol( 'Parent', this.vbox{1}, 'Style', 'text', 'String', 'Name',...
                'FontName','Helvetica','FontSize',8,'FontWeight','bold');
            uicontrol( 'Parent', this.vbox{2}, 'Style', 'text', 'String', 'Input',...
                'FontName','Helvetica','FontSize',8,'FontWeight','bold');
            uicontrol( 'Parent', this.vbox{3}, 'Style', 'text', 'String', 'Output',...
                'FontName','Helvetica','FontSize',8,'FontWeight','bold');
            uicontrol( 'Parent', this.vbox{4}, 'Style', 'text', 'String', 'Parameter',...
                'FontName','Helvetica','FontSize',8,'FontWeight','bold');
            uix.Empty( 'Parent', this.vbox{5});
            
            % add "add" pushbutton and empty space
            uicontrol( 'Parent', this.vbox{1},...
                       'Style','pushbutton',...
                       'FontSize',7,...
                       'String','Add Process',...
                       'Callback',@(src, event) addProcess(this));
            uix.Empty( 'Parent', this.vbox{2});
            uix.Empty( 'Parent', this.vbox{3});
            uix.Empty( 'Parent', this.vbox{4});
            uix.Empty( 'Parent', this.vbox{5});

            % set width
            this.hbox.Widths = [-1.8 -0.8 -0.8 -2 -0.7]; 
            
            % get the icons
            icons = load('icon.mat');
            this.ArrowIconUp = icons.arrow_up;
            this.ArrowIconDown = icons.arrow_down;
            this.DeleteIcon = icons.delete_ico;
        end %ProcessTab
    end
    
    methods (Access = public)
       % Add new line
       function this = addLine(this, name, intype, outtype, parameter)
           % check if this process already exists
           if isempty(this.ProcessArray)
               % just continue
           elseif all(strcmp({this.ProcessArray.functionName}, name) ~= 0)
               warndlg('This process have already been imported!', 'Warning')
               return
           end
           % add a new line to the current tab
            uicontrol( 'Parent', this.vbox{1}, 'Style', 'text', 'String', name,...
                'FontName','Helvetica','FontSize',8);
            uicontrol( 'Parent', this.vbox{2}, 'Style', 'text', 'String', intype,...
                'FontName','Helvetica','FontSize',8);
            uicontrol( 'Parent', this.vbox{3}, 'Style', 'text', 'String', outtype,...
                'FontName','Helvetica','FontSize',8);
            if ~isempty(parameter)
                % TO DO
            else
                uix.Empty( 'Parent', this.vbox{4});
            end
            % add some buttons
            h = uix.HButtonBox( 'Parent', this.vbox{5}, 'ButtonSize',[20 20]);
            uicontrol( 'Parent', h, 'Style', 'pushbutton',...
                'CData', this.ArrowIconUp, 'Tag', 'Up',...
                'Callback',@(src, event) moveProcess(this, src));
            uicontrol( 'Parent', h, 'Style', 'pushbutton',...
                'CData', this.ArrowIconDown, 'Tag', 'Down',...
                'Callback',@(src, event) moveProcess(this, src));
            uicontrol( 'Parent', h, 'Style', 'pushbutton',...
                'CData', this.DeleteIcon, 'Callback',@(src, event) removeProcess(this, src));
            % reorganize object
            cellfun(@(x) uistack(x.Children(1),'down'), this.vbox, 'Uniform', 0);
       end %addLine
       
       % Add new process
       function this = addProcess(this)
           % call the process selector
           [name, intype, outtype, parameter, processObj] = this.FitLike.processdlg();
           % check if empty and add the process
           if ~isempty(name)
                % add new line
                addLine(this, name, intype, outtype, parameter);
                % add processObj
                this.ProcessArray = [processObj this.ProcessArray];
           end
       end %addProcess
       
       % Remove process
       function this = removeProcess(this, src)
           % get the index of the selected delete button
           hChildren = src.Parent;
           hParent = hChildren.Parent;
           indx = hParent.Children == hChildren;
           % remove the processObj
           tf = strcmp(this.vbox{1}.Children(indx).String,...
               {this.ProcessArray.functionName});
           this.ProcessArray(tf) = [];
           % remove this line
           cellfun(@(x) delete(x.Children(indx)), this.vbox, 'Uniform', 0);
           
       end %removeProcess
       
       % Move process
       function this = moveProcess(this, src)
           % get the current position
           hChildren = src.Parent;
           hParent = hChildren.Parent;
           indx = find(hParent.Children == hChildren);
           n = numel(hParent.Children);
           % check which button was pressed
           if strcmp(src.Tag, 'Up')
               % check if we can move the line
               if indx < n - 1
                   % move up
                   cellfun(@(x) uistack(x.Children(indx),'down'), this.vbox, 'Uniform', 0);
                   % move process in the array
                   new_order = 1:n-2;
                   new_order(indx) = new_order(indx) - 1;
                   new_order(indx-1) = new_order(indx-1) + 1;
                   % reorder
                   this.ProcessArray = this.ProcessArray(new_order);    
               end
           else
               % check if we can move the line
               if indx > 2
                   % move down
                   cellfun(@(x) uistack(x.Children(indx),'up'), this.vbox, 'Uniform', 0);
                   % move process in the array
                   new_order = 1:n-2;
                   new_order(indx-1) = new_order(indx-1) - 1;
                   new_order(indx-2) = new_order(indx-2) + 1;
                   % reorder
                   this.ProcessArray = this.ProcessArray(new_order);
               end
           end
       end %moveProcess
    end
    
    methods (Static = true, Access = public)
       % Check process: is the pipeline consistent?
       function tf = checkProcess(this)
           % check number of process
           n = length(this.vbox{2}.Children) - 2;
           % check if empty
           if n < 1
               tf = 0;
               warndlg('No process to run pipeline!','Warning')
           else
               % check that input/output is consistent: bloc-->zone then
               % zone--> dispersion, not the opposite
               from = flip({this.vbox{2}.Children(2:end-1).String}); %get input format
               to = flip({this.vbox{3}.Children(2:end-1).String}); %get output format
                
               if ~strcmp(from{1},'bloc')
                   tf = 0;
                   warndlg('The pipeline need to start by a bloc type!', 'Warning')
               elseif n == 1
                   tf = 1;
               else
                   % check in/out format
                   for k = 1:n-1
                       outFormat = to{k};
                       inFormat = from{k+1};
                       if ~isequal(inFormat, outFormat)
                           tf = 0;
                           warndlg('The input/output type are not consistent to run pipeline!','Warning')
                           return
                       end
                   end
                   % valid pipeline
                   tf = 1;
               end
           end
       end %checkProcess
       
       % Get all the pipeline information as table
       function tb = getPipelineAsTable(this)
           % check if available data
           n = length(this.vbox{2}.Children) - 2;
           % if not empty table
           if n < 1
               name = {}; from = {}; to = {}; parameter = {};
               tb = table(name, from, to, parameter);
           else
               % get data
               name = {this.vbox{1}.Children(2:end-1).String}';
               from = {this.vbox{2}.Children(2:end-1).String}';
               to   = {this.vbox{3}.Children(2:end-1).String}';
               parameter   = repmat({''},length(to),1); % TO DO
               % set table
               tb = table(name, from, to, parameter);
           end
       end %getPipelineAsTable
    end
    
    methods (Access = public)
       % Set the pipeline from table
       function this = setPipelineFromTable(this, tb)
           % remove current pipeline if needed
           n = length(this.vbox{2}.Children) - 2;

           if n > 0
               cellfun(@(x) delete(x.Children(2:end-1)), this.vbox, 'Uniform',0);
           end
           
           % fill the pipeline from the last process to the first.
           for k = height(tb):-1:1
               addLine(this, tb.name{k}, tb.from{k}, tb.to{k}, tb.parameter{k});
           end
       end %setPipelineFromTable
    end
    
end
