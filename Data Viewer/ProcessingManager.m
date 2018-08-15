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
            
            % Set the first tab
            ProcessTab(FitLike, uitab(this.gui.tab),'Pipeline1');
            %%-------------------------CALLBACK--------------------------%%
            % Replace the close function by setting the visibility to off
            set(this.gui.fig,  'closerequestfcn', ...
                @(src, event) this.FitLike.hideWindowPressed(src));    
            
            set(this.gui.AddPipelinePushButton, 'callback',...
                @(src, event) addProcessTab(this));
            
            set(this.gui.RemovePipelinePushButton, 'callback',...
                @(src, event) removeProcessTab(this));
            
            set(this.gui.RenamePipelinePushButton, 'callback',...
                @(src, event) renameProcessTab(this));
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
                    for i = 1:numel(hSequence.Children)
                        hFile = hSequence.Children(i);
                        delete(hFile.Children)
                    end
                end
            end
        end %updateTree
        
        % Add ProcessTab
        function this = addProcessTab(this)
            % count tab
            nTab = numel(this.gui.tab.Children);
            % add new tab
            ProcessTab(this.FitLike, uitab(this.gui.tab),['Pipeline',num2str(nTab + 1)]);
        end
        
        % Remove ProcessTab
        function this = removeProcessTab(this)
            % check tab state
            if numel(this.gui.tab.Children) < 2
                return
            else
                % delete current tab
                delete(this.gui.tab.SelectedTab);
            end
        end
        
        % Remame ProcessTab
        function this = renameProcessTab(this)
            % get the index of the selected tab
            idx = find(this.gui.tab.Children == this.gui.tab.SelectedTab);
            % open inputdlg
            new_name = inputdlg({'Enter a new pipeline name:'},...
                'Rename Pipeline',[1 70],{['Pipeline',num2str(idx)]});
            % check output and assign new name
            if isempty(new_name)
                return
            else
                this.gui.tab.SelectedTab.Title = new_name{1};
            end
        end
    end   
end

