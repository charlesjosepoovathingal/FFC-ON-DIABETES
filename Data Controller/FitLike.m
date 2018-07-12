classdef FitLike < handle
    %
    % Presenter for the FitLike software. See MVP model.
    %
    
    properties (Access = public)
        RelaxData % Model for the Presenter
        FitLikeView % Main view for the Presenter
        FileManager % Other view for the Presenter (subView)
        DisplayManager % Other view for the Presenter (subView)
%         ProcessingManager % Other view for the Presenter  (subView)
%         ModelManager % Other view for the Presenter (subView)
%         AcquisitionManager % Other view for the Presenter (subView)
    end
    
    methods (Access = public)
        % Constructor
        function this = FitLike()
            % create subView
            this.FileManager = FileManager(this);
            this.DisplayManager = DisplayManager(this);
            % this.ProcessingManager = ProcessingManager(this);
            % this.ModelManager = ModelManager(this);
            % this.AcquisitionManager = AcquisitionManager(this);

            % Add the main View
            this.FitLikeView = FitLikeView(this);
        end %FitLike
        
        % Destructor             
        function closeWindowPressed(this)
           % Delete everything
           this.FitLikeView.deleteWindow();
           this.FileManager.deleteWindow();
           this.DisplayManager.deleteWindow();
%          this.ProcessingManager.deleteWindow();
%          this.ModelManager.deleteWindow();
%          this.AcquisitionManager.deleteWindow();

           % Delete this and clear to avoid memory leak
           delete(this);
           clear this
        end %closeWindowPressed
    end
    
    %% ----------------------- Menu Callback --------------------------- %%
    methods (Access = public)
        %%% File Menu
        % Open function: allow to open new files or dataset (.sdf, .sef, .mat)
        function this = open(this)
            % open interface to select files
            [file, path, indx] = uigetfile({'*.sdf','Stelar Raw Files (*.sdf)';...
                                     '*.sef','Stelar Processed Files (*.sef)';...
                                     '*.mat','FitLike Dataset (*.mat)'},...
                                     'Select One or More Files', ...
                                     'MultiSelect', 'on');
            % check output
            if isequal(file,0)
                % user canceled
                return
            elseif ischar(file)
                file = {file};
            end
            % switch depending on the type of file
            switch indx
                case 1 %sdf
                    for i = 1:length(file)
                        filename = [path file{i}];
                        % check version and select the correct reader
                        ver = checkversion(filename);
                        if ver == 1
                            [data, parameter] = readsdfv1(filename);
                        else
                            [data, parameter] = readsdfv2(filename);
                        end
                        % format the output
                        % TO DO:
                    end
                case 2 %sef
                    for i = 1:length(file)
                        filename = [path file{i}];
                        % read the file
                        [x,y,dy] = readsef(filename);
                        % format the output
                        % TO DO
                    end
                case 3 %mat
                    for i = 1:length(file)
                        filename = [path file{i}];
                        % read the .mat file
                        obj = load(filename);
                        % format the output
                        % TO DO
                    end
            end
            % update FileManager
            % TO DO
        end %open
        
        % Remove funcion: allow to remove files, sequence, dataset
        function this = remove(this)
            
        end %remove
        
        % Export function: allow to export data (dispersion, model)
        function export(this, src)
            
        end %export
        
        % Save function: allow to save all data in .mat dataset
        function save(this)
            
        end %export
        
        % Close function: see closeWindowPressed(this)

        
        %%% Edit Menu
        % Move function: allow to move files to another sequence, dataset
        function this = move(this)
            
        end %move
        
        % Copy function : allow to copy files to another sequence, dataset
        function this = copy(this)
            
        end %copy
        
        % Sort function: allow to sort files, sequence or dataset
        function this = sort(this, src)
            
        end %sort
        
        % Merge function: allow to merge/unmerge files
        function this = merge(this)
            
        end %merge
        
        % Mask function: allow to mask data in DisplayManager
        function this = mask(this)
            
        end %mask
        
        
        %%% View Menu
        % Axis function: allow to set the axis scaling
        function this = setAxis(this, src)
            
        end %setAxis
        
        % Plot function: allow to plot data by name or label
        function this = setPlot(this, src)
            
        end %setPlot
        
        % CreateFig function: allow to export current axis in new figure
        function createFig(this)
            % get the handle of the selected tab
            h = this.DisplayManager.gui.tab.SelectedTab;
            % call createFig() in the concerned tab
            createFig(h.Children);
        end %createFig
        
        
        %%% Tool Menu
        % Filter function: allow to apply filters on data
        function this = applyFilter(this)
            
        end %applyFilter
        
        % Mean function: allow to average files in a new one
        function this = average(this)
            
        end %average
        
        % Normalise: allow to normalise data
        function this = normalise(this)
            
        end %normalise
        
        % BoxPlot: allow to plot model results as boxplot
        function this = boxplott(this)
            
        end %boxplott
        
        
        %%% Display Menu
        % Show/Hide FileManager, DisplayManager, Processing Manager,...
        function showWindow(this, src)
            % determine the figure concerned
            switch src.Tag
                case 'FileManager'
                    % check if figure already displayed
                    if strcmp(src.Checked,'on')
                        this.FileManager.gui.fig.Visible = 'off';
                        this.FitLikeView.gui.FileManager.Checked = 'off';
                    else
                        this.FileManager.gui.fig.Visible = 'on';
                        this.FitLikeView.gui.FileManager.Checked = 'on';
                    end
                case 'DisplayManager'
                    % check if figure already displayed
                    if strcmp(src.Checked,'on')
                        this.DisplayManager.gui.fig.Visible = 'off';
                        this.FitLikeView.gui.DisplayManager.Checked = 'off';
                    else
                        this.DisplayManager.gui.fig.Visible = 'on';
                        this.FitLikeView.gui.DisplayManager.Checked = 'on';
                    end
                case 'ProcessingManager'
                    % check if figure already displayed
                    if strcmp(src.Checked,'on')
                        this.ProcessingManager.gui.fig.Visible = 'off';
                        this.FitLikeView.gui.ProcessingManager.Checked = 'off';
                    else
                        this.ProcessingManager.gui.fig.Visible = 'on';
                        this.FitLikeView.gui.ProcessingManager.Checked = 'on';
                    end
                case 'ModelManager'
                    % check if figure already displayed
                    if strcmp(src.Checked,'on')
                        this.ModelManager.gui.fig.Visible = 'off';
                        this.FitLikeView.gui.ModelManager.Checked = 'off';
                    else
                        this.ModelManager.gui.fig.Visible = 'on';
                        this.FitLikeView.gui.ModelManager.Checked = 'on';
                    end
                case 'AcquisitionManager'
                    % check if figure already displayed
                    if strcmp(src.Checked,'on')
                        this.AcquisitionManager.gui.fig.Visible = 'off';
                        this.FitLikeView.gui.AcquisitionManager.Checked = 'off';
                    else
                        this.AcquisitionManager.gui.fig.Visible = 'on';
                        this.FitLikeView.gui.AcquisitionManager.Checked = 'on';
                    end
            end
        end %showWindow

        
        %%% Help Menu
        % Documentation function: allow to open the user documentation
        function help(this)
            
        end %help
    end      
    %% --------------------- FileManager Callback ---------------------- %%  
    methods (Access = public)
        % File selection callback
        function selectFile(this, ~, event)
            % get the new values
            val = event.EditData;
            row = event.Indices(1);
            col = event.Indices(2);
            % check if files selected
            if col
                if val 
                    addPlot(this);
                else
                    removePlot(this);
                end
            end
        end %selectFile
    end   
    %% -------------------- DisplayManager Callback -------------------- %% 
    methods (Access = public)
        % Tab selection callback: add new tab
        function selectTab(this, src)
            % reset FileManager selection
            selection = false(size(this.FileManager.gui.table.Data(:,1)));
            this.FileManager.gui.table.Data(:,1) = num2cell(selection);
            % check if user select the '+' tab or another one
            if strcmp(src.SelectedTab.Title,'+')
                % add tab
                addTab(this.DisplayManager);
            elseif strcmp(src.SelectedTab.Title,'Dispersion')
                % update FileManager to fit with DisplayManager
                listFileID = getFileID(src.SelectedTab.Children);
                fileID = strcat(this.RelaxObj.dataset,...
                            this.RelaxObj.sequence,...
                            this.RelaxObj.filename);
                [~,indx,~] = intersect(fileID, listFileID);
                % set the displayed file as selected
                this.FileManager.gui.table.Data(indx,1) = num2cell(true(length(indx),1));
            end
        end %selectTab
        
        % Tab destructor callback: UIContextMenu in DisplayManager
        function removeTab(this, src)
            % check the number of displayed tabs
            n = length(this.DisplayManager.gui.tab.Children);
            % check if one tab is left (not including '+' tab)           
            if n < 3
                % disp error or warning! Not enough tabs
                return
            end
            % Use Tag to know the tab index concerned and re-order it to
            % fit with Matlab child storage order.
            indx = str2double(src.Tag(end));
            % close the tab
            removeTab(this.DisplayManager, indx);
            % reset FileManager
            selectTab(this, this.DisplayManager.gui.tab);
        end %removeTab
        
        % Add plot to the current tab/axis
        function this = addPlot(this)
            % get the handle of the selected tab
            h = this.DisplayManager.gui.tab.SelectedTab; 
            % check the selected data
            selection = [this.FileManager.gui.table.Data{:,1}];
            % get the corresponding data
            data = this.RelaxObj.data(selection);
            label = this.RelaxObj.filename(selection);
            seq = this.RelaxObj.sequence(selection);
            dataset = this.RelaxObj.dataset(selection);
            % select an action according to this type
            switch class(h.Children)
                case 'EmptyTab'
                    % if empty just replace the empty tab by the adapted
                    % tab
                    if isa(data,'Dispersion')
                         % add a new container to this tab and delete the
                         % other
                         DispersionTab(this, h);
                         delete(h.Children(2));
                         % check for type input and remove non consistent
                         % ones
                         % TO DO
                         % call plot of this tab
                         addPlot(h.Children, {data.x}, {data.y}, {data.dy},...
                             label,strcat(dataset,seq,label),{data.mask},{data.model});
                    elseif isa(data,'Zone') || isa(data,'Bloc')
                        
                    else 
                        disp('Error!')
                    end                   
                case 'DispersionTab'
                    % check if input are consistent
                    % TO DO
                    % add to current tab/axis
                    addPlot(h.Children, {data.x}, {data.y}, {data.dy},...
                         label,strcat(dataset,seq,label),{data.mask},{data.model});
            end            
        end %addPlot
        
        % Remove plot from the current tab/axis
        function this = removePlot(this)
            % get the handle of the selected tab
            h = this.DisplayManager.gui.tab.SelectedTab; 
            % check the selected data
            selection = [this.FileManager.gui.table.Data{:,1}];
            % get the fileID of the selected data
            fileID = strcat(this.RelaxObj.dataset(selection),...
                this.RelaxObj.sequence(selection),...
                this.RelaxObj.filename(selection));
            % get the list of the current axis
            listFileID = getFileID(h.Children);
            % setdiff
            fileID = setdiff(listFileID,fileID);
            % remove these lines
            removePlot(h.Children, fileID);
        end %removePlot
        
        % update plot
        function this = updatePlot(this,src)
            % get the handle of the selected tab
            h = this.DisplayManager.gui.tab.SelectedTab; 
            % call the update function of the concerned tab
            update(h.Children, src);
        end %updatePlot
    end
    %% ------------------ ProcessingManager Callback ------------------- %%
    methods (Access = public)
        
    end
    %% --------------------- ModelManager Callback --------------------- %%
     methods (Access = public)
        
    end
    %% ------------------ AcquisitionManager Callback ------------------ %%
    methods (Access = public)
        
    end
    %% ------------------------ Others Callback ------------------------ %%
    methods (Access = public)     
        % Close subView callback: hide figure
        function hideWindowPressed(this, src)
            % determine the figure concerned and call showWindow() to close
            % it
            state.Checked = 'on';
            state.Tag = strrep(src.Name,' ',''); %just remove space
            showWindow(this,state);
        end %hideWindowPressed     
    end    
end

