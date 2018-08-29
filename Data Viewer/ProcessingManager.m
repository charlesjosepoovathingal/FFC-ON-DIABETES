classdef ProcessingManager < handle
    %
    % View for ProcessingManager in FitLike
    %
    
    properties
        gui % GUI (View)
        FitLike % Presenter
    end
    
    methods
        % Constructor
        function this = ProcessingManager(FitLike)
            %%--------------------------BUILDER--------------------------%%
            % Store a reference to the presenter
            this.FitLike = FitLike;
                      
            % Make the figure
            gui = buildProcessingManager();
            this.gui = guihandles(gui);     
            
            % Set the first tab and the '+' tab
            ProcessTab(uitab(this.gui.tab),'Pipeline1');
            EmptyPlusTab(uitab(this.gui.tab));
            
            % Set the UI ContextMenu
            setUIMenu(this);
            %%-------------------------CALLBACK--------------------------%%
            % Replace the close function by setting the visibility to off
            set(this.gui.fig,  'closerequestfcn', ...
                @(src, event) this.FitLike.hideWindowPressed(src));    
            
            % Set SelectionChangedFcn callback for tab
            set(this.gui.tab, 'SelectionChangedFcn',...
                @(src, event) selectPipeline(this));
            
            % Set callback for the radio buttons
            set(this.gui.BatchRadioButton, 'Callback',...
                @(src, event) switchProcessMode(this, src));
            set(this.gui.SimulationRadioButton, 'Callback',...
                @(src, event) switchProcessMode(this, src));
            
            % Set callback for the run pushbutton
            set(this.gui.RunPushButton, 'Callback',...
                @(src, event) this.FitLike.runProcess());
        end %ProcessingManager
        
        % Destructor
        function deleteWindow(this)
            %remove the closerequestfcn from the figure, this prevents an
            %infitie loop with the following delete command
            set(this.gui.fig,  'closerequestfcn', '');
            %delete the figure
            delete(this.gui.fig);
            %clear out the pointer to the figure - prevents memory leaks
            this.gui = [];
        end  %deleteWindow 
    end
    
    methods (Access = public)
        % Set UIContextMenu
        function this = setUIMenu(this)
            % set contextmenu to the selected tab
            cmenu = uicontextmenu(this.gui.fig);
            uimenu(cmenu, 'Label', 'Rename pipeline',...
                'Callback',@(src,event) renamePipeline(this));
            uimenu(cmenu, 'Label', 'Load pipeline',...
                'Callback',@(src,event) loadPipeline(this));
            uimenu(cmenu, 'Label', 'Save pipeline',...
                'Callback',@(src,event) savePipeline(this));
            uimenu(cmenu, 'Label', 'Delete pipeline',...
                'Callback',@(src,event) removePipeline(this));  
            this.gui.tab.SelectedTab.UIContextMenu = cmenu;  
        end
        
        % Update tree
        function this = updateTree(this)
            % define new parent container
            hParent = this.gui.tree.UserData.Root;
            % delete children
            if ~isempty(hParent.Children)
                delete(hParent.Children)
            end
            % get children
            hChildren = this.FitLike.FileManager.gui.tree.Root.Children;
            % get the tree from FileManager
            copy(hChildren, hParent);
            % delete all relaxObj: just select files
            for k = 1:numel(hParent.Children)
                hDataset = hParent.Children(k);
                for j = 1:numel(hDataset.Children)
                    hSequence = hDataset.Children(j);
                    %%%----------------------------%%%
                    if strcmp(hSequence.Name,'IRCPMG/S [DefaultFfcSequences.ssf]')
                        hSequence.Checked = 1;
                    end
                    %%%----------------------------%%%
                    for i = 1:numel(hSequence.Children)
                        hFile = hSequence.Children(i);
                        delete(hFile.Children)
                    end
                end
            end
        end %updateTree
        
        % Select Pipeline
        function this = selectPipeline(this)
            if strcmp(this.gui.tab.SelectedTab.Title,'+')
                addPipeline(this);
            end
        end %selectPipeline
        
        % Add Pipeline
        function this = addPipeline(this)
            % count tab
            nTab = numel(this.gui.tab.Children);
            % add new tab
            ProcessTab(uitab(this.gui.tab),['Pipeline',num2str(nTab)]);
            % push this tab
            uistack(this.gui.tab.Children(end),'up');
            % set the selection to this tab
            this.gui.tab.SelectedTab = this.gui.tab.Children(end-1);
            % add UI menu to this tab
            setUIMenu(this);          
        end %addPipeline
        
        % Remove Pipeline
        function this = removePipeline(this)
            % check tab state
            if numel(this.gui.tab.Children) < 3
                return
            else
                % delete current tab
                delete(this.gui.tab.SelectedTab);
                % check if '+' tab selected
                if strcmp(this.gui.tab.SelectedTab.Title,'+')
                    this.gui.tab.SelectedTab = this.gui.tab.Children(end-1);
                end
            end
        end %removePipeline
        
        % Remame Pipeline
        function this = renamePipeline(this)
            % get the index of the selected tab
            idx = find(this.gui.tab.Children == this.gui.tab.SelectedTab);
            % open inputdlg
            new_name = inputdlg({'Enter a new pipeline name:'},...
                'Rename Pipeline',[1 70],{['Pipeline',num2str(idx)]});
            % check output and assign new name
            if ~isempty(new_name)
                this.gui.tab.SelectedTab.Title = new_name{1};
            end
        end %renamePipeline
        
        % Load Pipeline
        function this = loadPipeline(this)
            % open dlg box
            %%%-------------------------------------------------------%%%
%              [file, path] = uigetfile({'*.mat','MAT-files (*.mat)'},...
%                'Select a pipeline');
            path = 'C:/Users/Manu/Documents/GitHub/FitLike2/Data Controller/Data processing/Pipeline Saved';
            file = 'myPipeline.mat';
            %%%-------------------------------------------------------%%%
            % load data
            if ischar(file)
                % check if valid file
                vars = {'processArray','pipelineTable'};
                try
                    pipeline = load([path,'/',file],vars{:});
                catch 
                    warndlg('The selected pipeline is not valid!','Pipeline selection')
                    return
                end
                % set data
                this.gui.tab.SelectedTab.Children.ProcessArray = pipeline.processArray;
                setPipelineFromTable(this.gui.tab.SelectedTab.Children,...
                                             pipeline.pipelineTable);
            end
        end %loadPipeline
        
        % Save Pipeline
        function this = savePipeline(this)
            % get the data from the selected tab
            processArray = this.gui.tab.SelectedTab.Children.ProcessArray; %#ok<NASGU>
            % concatenate the other data
            pipelineTable = ProcessTab.getPipelineAsTable(this.gui.tab.SelectedTab.Children); %#ok<NASGU>
            % choose a name
            uisave({'processArray','pipelineTable'},'myPipeline')
        end %savePipeline
        
        % Switch Process Mode
        function this = switchProcessMode(this, src)
            % check if we need to change the value
            if all([src.Parent.Children.Value] == 1)
                % check the source and reset the other one
                switch src.Tag
                    case 'BatchRadioButton'
                        this.gui.SimulationRadioButton.Value = 0;
                    case  'SimulationRadioButton'
                        this.gui.BatchRadioButton.Value = 0;
                end
            else
                src.Value = 1; % always select one item
            end
        end %switchProcessMode
    end  
end

