classdef FitLike < handle
    %
    % Presenter for the FitLike software. See MVP model.
    %
    
    properties (Access = public)
        RelaxData % Model for the Presenter
        FitLikeView % Main view for the Presenter
        FileManager % Other view for the Presenter (subView)
        DisplayManager % Other view for the Presenter (subView)
        ProcessingManager % Other view for the Presenter  (subView)
        ModelManager % Other view for the Presenter (subView)
%         AcquisitionManager % Other view for the Presenter (subView)
    end
    
    methods (Access = public)
        % Constructor
        function this = FitLike()
            % create subView
            this.FileManager = FileManager(this);
            this.DisplayManager = DisplayManager(this);
            this.ProcessingManager = ProcessingManager(this);
            this.ModelManager = ModelManager(this);
            % this.AcquisitionManager = AcquisitionManager(this);

            % Add the main View
            this.FitLikeView = FitLikeView(this);
            
            %%%-----------%%%
            % call open
            open(this);
            loadPipeline(this.ProcessingManager);
            % runProcess
            runProcess(this);
            % expand
            expand(this.FileManager.gui.tree.Root.Children.Children(3));
            expand(this.FileManager.gui.tree.Root.Children.Children(3).Children);
            % select IRCPMG files
            tf = strcmp({this.RelaxData.sequence}, 'IRCPMG/S [DefaultFfcSequences.ssf]');
            fileID2tree(this.FileManager, {this.RelaxData(tf).fileID}, 'check');
            % fire callback
            event.Nodes = this.FileManager.gui.tree.Root.Children.Children(3);
            selectFile(this, this, event);
            %%%-----------%%%
        end %FitLike
        
        % Destructor             
        function closeWindowPressed(this)
           % Delete everything
           this.FitLikeView.deleteWindow();
           this.FileManager.deleteWindow();
           this.DisplayManager.deleteWindow();
           this.ProcessingManager.deleteWindow();
           this.ModelManager.deleteWindow();
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
            %%%%---------------------%%%%
%             [file, path, indx] = uigetfile({'*.sdf','Stelar Raw Files (*.sdf)';...
%                                      '*.sef','Stelar Processed Files (*.sef)';...
%                                      '*.mat','FitLike Dataset (*.mat)'},...
%                                      'Select One or More Files', ...
%                                      'MultiSelect', 'on');
            
            path = 'C:/Users/Manu/Desktop/FFC-NMR DATA/PIGS/SAIN/2/';
            file = {'20170728_cochonsain2_corpscalleux2_ML.sdf',...
                    '20170728_cochonsain2_corpscalleux4_ML.sdf',...
                    '20170728_cochonsain2_corpscalleux2_QP_ML.sdf'};
            indx = 1;
            %%%%---------------------%%%%
            % check output
            if isequal(file,0)
                % user canceled
                return
            elseif ischar(file)
                file = {file};
            end
            % initialisation
            bloc = [];
            % switch depending on the type of file
            switch indx
                case 1 %sdf
                    % enter dataset
                    if isempty(this.RelaxData)
                        %%%-------------%%%
%                         dataset = inputdlg({'Enter a dataset name:'},...
%                             'Create dataset',[1 70],{'myDataset'});
                        
                        dataset = 'myDataset';
                        %%%-------------%%%
                    else
                        % ask user in which dataset we need to put files
                        res = questdlg('Where do you want to import your data?',...
                            'Importation','Existing dataset','New dataset',...
                            'Existing dataset');
                        switch res
                            case 'Existing dataset'
                                list = unique({this.RelaxData.dataset});
                                [indx,~] = listdlg('PromptString','Select a dataset',...
                                    'SelectionMode','single',...
                                    'ListString',list);
                                dataset = list(indx);
                            case 'New dataset'
                                dataset = inputdlg({'Enter a dataset name:'},...
                              'Create dataset',[1 70],{'myDataset'});
                            otherwise 
                                return
                        end
                    end
                    % check dataset output
                    if isempty(dataset)
                        return
                    elseif ischar(dataset)
                        dataset = {dataset};
                    end
                        
                    % loop over the files
                    for i = 1:length(file)
                        filename = [path file{i}];
                        % check version and select the correct reader
                        ver = checkversion(filename);
                        if isequal(ver,1)
                            [data, parameter] = readsdfv1(filename);
                        else
                            [data, parameter] = readsdfv2(filename);
                        end
                        % get the data
                        y = cellfun(@(x,y) complex(x,y), data.real, data.imag,...
                            'UniformOutput',0);
                        name = getfield(parameter,'FILE','ForceCellOutput','True');
                        sequence = getfield(parameter,'EXP','ForceCellOutput','True');
                        % format the output
                        new_bloc = Bloc('x',data.time,'y',y,...
                            'xLabel',repmat({'Time'},1,length(name)),...
                            'yLabel',repmat({'Signal'},1,length(name)),...
                            'parameter',num2cell(parameter),...
                            'filename',name,'sequence',sequence,...
                            'dataset',repmat(dataset,1,length(name)));
                        % check duplicates
                        if ~isempty(this.RelaxData)
                            new_bloc = checkDuplicates(this, new_bloc);
                        end
                        % append them to the current data
                        bloc = [bloc new_bloc]; %#ok<AGROW>
                    end
                case 2 %sef
                    % enter dataset
                    if isempty(this.RelaxData)
                    dataset = inputdlg({'Enter a dataset name:'},...
                        'Create dataset',[1 70],{'myDataset'});
                    else
                        % ask user in which dataset we need to put files
                        res = questdlg('Where do you want to import your data?',...
                            'Importation','Existing dataset','New dataset',...
                            'Existing dataset');
                        switch res
                            case 'Existing dataset'
                                list = unique({this.RelaxData.dataset});
                                [indx,~] = listdlg('PromptString','Select a dataset',...
                                    'SelectionMode','single',...
                                    'ListString',list);
                                dataset = list(indx);
                            case 'New dataset'
                                dataset = inputdlg({'Enter a dataset name:'},...
                              'Create dataset',[1 70],{'myDataset'});
                            otherwise 
                                return
                        end
                    end
                    % check dataset output
                    if isempty(dataset)
                        return
                    elseif ischar(dataset)
                        dataset = {dataset};
                    end
                    % loop over the files
                    for i = 1:length(file)
                        filename = [path file{i}];
                        % read the file
                        [x,y,dy] = readsef(filename);
                        % format the output
                        new_bloc = Dispersion('x',x,'xLabel','Magnetic Field (MHz)',...
                            'y',y,'dy',dy,'yLabel','Relaxation Rate R_1 (s^{-1})',...
                            'filename',file{i},'sequence','Unknown','dataset',dataset);
                        % check duplicates
                        if ~isempty(this.RelaxData)
                            new_bloc = checkDuplicates(this, new_bloc);
                        end
                        % append them to the current data
                        bloc = [bloc new_bloc]; %#ok<AGROW>
                    end
                case 3 %mat
                    for i = 1:length(file)
                        filename = [path file{i}];
                        % read the .mat file
                        obj = load(filename);
                        var = fieldnames(obj);
                        % check if no doublons. If true, change filename?
                        % remove files?
                        % append them to the current data
                        % check duplicates
                        bloc = [bloc obj.(var{1})]; %#ok<AGROW>
                        if ~isempty(this.RelaxData)
                            new_bloc = checkDuplicates(this, new_bloc);
                        end
                    end
            end
            % append data to RelaxData
            this.RelaxData = [this.RelaxData bloc];
            % update FileManager
            addData(this.FileManager,repmat({'bloc'},[1,size(bloc)]),...
                {bloc.dataset}, {bloc.sequence},...
                {bloc.filename}, {bloc.displayName});
            % update ProcessingManager
            updateTree(this.ProcessingManager);
            updateTree(this.ModelManager);
                %%-------------------------------------------------------%%
                % Check if duplicates are imported and let the user decides
                % if we keep them and add '_bis' to their filename or just
                % remove them from the current array of object "bloc".
                function bloc = checkDuplicates(this, bloc)
                    % check if duplicates have been imported
                    [~,idx,~] = intersect({bloc.fileID}, {this.RelaxData.fileID});
                    if ~isempty(idx)
                        % create a cell array of string with:
                        % 'filename' (Sequence: 'sequence')
                        listDuplicate = arrayfun(@(x) sprintf(['%s\t'...
                            '(Sequence: %s)'],x.filename,x.sequence),...
                            bloc(idx),'UniformOutput',0);
                        % ask the user what to do
                        answer = questdlg(sprintf(['The following files '...
                           'are already stored in FitLike:\n\n%s\nDo you '...
                           'still want to keep them or not?\n'...
                           'Note: Filename will be changed if Yes'],...
                           sprintf('%s \n',listDuplicate{:})),...
                           'Importation','Yes','No','No');
                       if strcmp(answer,'Yes')
                           % rename bloc: add '_bis'
                           new_filename = arrayfun(@(x) [x.filename '_bis'],...
                               bloc(idx),'UniformOutput',0);
                           [bloc(idx).filename] = new_filename{:};
                       else
                           % delete duplicated
                           bloc(idx) = [];
                       end
                    end
                end %checkDuplicated
                %%-------------------------------------------------------%%
        end %open
        
        % Remove funcion: allow to remove files, sequence, dataset
        function this = remove(this)
            % check the selected files in FileManager
            nodes = this.FileManager.gui.tree.CheckedNodes;
            fileID = FileManager.Checkbox2fileID(nodes); %#ok<PROP>
            % remove files in RelaxData 
            [~,idx,~] = intersect({this.RelaxData.fileID},fileID);
            this.RelaxData = delete(this.RelaxData, idx);
            % update FileManager
            removeData(this.FileManager);
            % update ProcessingManager
            updateTree(this.ProcessingManager);
            updateTree(this.ModelManager);
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
            % according to the current visibility, change it
            if strcmp(src.Checked,'on')
                src.Checked = 'off';
                this.(src.Tag).gui.fig.Visible = 'off';
            else
                src.Checked = 'on';
                this.(src.Tag).gui.fig.Visible = 'on';
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
            % check if nodes was selected
            if ~isempty(event.Nodes)
                % avoid problems: enable 'off'
                this.FileManager.gui.tree.Enable = 'off';
                % get the fileID list of the checked object
                fileID = FileManager.Checkbox2fileID(event.Nodes); %#ok<PROPLC>
                % get the corresponding index
                [~,indx,~] = intersect({this.RelaxData.fileID}, fileID);
                % check the state of the node
                if event.Nodes.Checked
                    % add data to current plot
                    [~, plotFlag, tf] = addPlot(this.DisplayManager, this.RelaxData(indx));
                    % check if everything have been plotted 
                    if ~plotFlag
                        str = cellfun(@(x,y) sprintf('%s (Sequence: %s)',x,y),...
                                {this.RelaxData(indx(tf)).filename},...
                                {this.RelaxData(indx(tf)).sequence},'Uniform',0);
                        warndlg(sprintf(['The following data have not been '...
                            'displayed because their type do not fit with '...
                            'the graph type: \n\n%s.'], sprintf('%s \n',str{:})))
                        % uncheck these nodes
                        fileID2tree(this.FileManager,...
                            {this.RelaxData(indx(tf)).fileID}, 'uncheck');
                    end
                else
                    % add data from the current plot
                    removePlot(this.DisplayManager, this.RelaxData(indx));
                end
                % enable tree
                this.FileManager.gui.tree.Enable = 'on';
            end
            
        end %selectFile
    end   
    %% -------------------- DisplayManager Callback -------------------- %% 
    methods (Access = public)
        % Tab selection callback
        function selectTab(this, src)
            % get the selected tab
            hTab = src.SelectedTab.Children;
            resetTree(this.FileManager);
            if isa(hTab,'EmptyPlusTab')
                % add new tab
                addTab(this.DisplayManager);
            elseif isa(hTab,'EmptyTab')
                % dumb
            elseif isa(hTab,'DispersionTab')
                % get the fileID plotted and check them
                fileID = getFileID(hTab);
                fileID2tree(this.FileManager,fileID,'check');
            end
        end %selectTab
    end
    %% ------------------ ProcessingManager Callback ------------------- %%
    methods (Access = public)
        % Run process
        function this = runProcess(this)
            % check if data are selected
            nodes = this.ProcessingManager.gui.tree.UserData.CheckedNodes;
            fileID = FileManager.Checkbox2fileID(nodes); %#ok<PROP>
            % according to the mode process, run it
            if isempty(fileID)
                warndlg('You need to select file to run process!','Warning')
                return
            elseif this.ProcessingManager.gui.BatchRadioButton.Value
                % Batch mode
                tab = this.ProcessingManager.gui.tab.SelectedTab.Children;
                % check the selected pipeline
                tf = ProcessTab.checkProcess(tab);
                % check output
                if tf
                    % get the process array
                    ProcessArray = flip(tab.ProcessArray);
                    % loop over the file
                    for k = 1:numel(fileID)
                        % get fileID
                        ifileID = split(fileID{k},'@');
                        % check for correspondance
                        indx = find(strcmp(ifileID{1},{this.RelaxData.dataset}) &... 
                            strcmp(ifileID{2},{this.RelaxData.sequence}) &... 
                            strcmp(ifileID{3},{this.RelaxData.filename}));
                        % get the ancestor
                        bloc = this.RelaxData(indx(1)); %take the first one
                        while ~isempty(bloc.parent)
                            bloc = bloc.parent;
                        end
                        % create a copy of the object, for the process
                        relaxObj = copy(bloc);
                        if ~isempty(relaxObj.children)
                            remove(relaxObj.children); % remove children
                        end
                        % apply the pipeline
                        for j = 1:numel(ProcessArray) 
                            % assign the process
                            assignProcessingFunction(relaxObj, ProcessArray(j));
                            % apply the process
                            relaxObj = processData(relaxObj);
                        end                        
                        % replace the new relaxObj in the main array
                        this.RelaxData = remove(this.RelaxData, indx);
                        this.RelaxData = [this.RelaxData, relaxObj];
                        % update FileManager
                        this.FileManager = fileID2tree(this.FileManager, fileID(k), 'delete'); %delete old file
                        % loop over the new obj
                        for i = 1:numel(relaxObj)
                           addData(this.FileManager, class(relaxObj(i)),...
                               relaxObj(i).dataset, relaxObj(i).sequence,...
                               relaxObj(i).filename,relaxObj(i).displayName);
                        end
                    end %for
                end
            else
                % Simulation mode
                % TO DO
            end
            % update model tree
            updateTree(this.ModelManager);
        end %runProcess
    end
    
    methods (Access = public, Static = true)
        
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
            tag = strrep(src.Name,' ',''); %just remove space
            src = this.FitLikeView.gui.(tag);
            showWindow(this, src);
        end %hideWindowPressed    
    end
end

