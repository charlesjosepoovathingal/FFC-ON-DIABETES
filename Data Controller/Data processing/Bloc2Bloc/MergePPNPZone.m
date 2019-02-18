classdef MergePPNPZone < Zone2Zone & ProcessDataUnit
    
    properties
        %InputChildClass@char; 	% defined in DataUnit2DataUnit
        %OutputChildClass@char;	% defined in DataUnit2DataUnit
        functionName@char = 'Merge NP/PP zones';     % character string, name of the model, as appearing in the figure legend
        labelY@char = '';       % string, labels the Y-axis data in graphs
        labelX@char = '';             % string, labels the X-axis data in graphs
        legendTag@cell = {'Merged'};         % tag appearing in the legend of data derived from this object
    end
        
    methods
        % Constructor
        function this = MergePPNPZone()
            % call both superclass constructor
            this = this@Zone2Zone;
            this = this@ProcessDataUnit;
            % set the ForceDataCat flag to true. Allow to get all the 3D
            % bloc matrix.
            % Warning: output data should be formated as:
            % new_data.x = NBLK x BRLX matrix
            % new_data.y = NBLK x BRLX matrix
            % ...
            %
            this.ForceDataCat = true;
            this.globalProcess = true;
        end % AverageAbs
    end
    
    methods
        % Define abstract method applyProcess(). See ProcessDataUnit.
        function mergedList = applyProcess(this, zoneList)
            
            
%             % only perform the merge operation once
%             if ~isequal(data.y,dataList(1).y)                
%                 return
%             end
            
            % make sure this is the very first data set of the
            % selection (to run this process only once)
%             relaxObj = getSelectedFile(fitlikeHandle.FileManager);
%             bloclist = getData(relaxObj(1), 'Bloc');
%             firstdata = getProcessData(this, bloclist(1));
%             if ~isequal(data.y,firstdata.y)
%                 return
%             end
%            
            relaxObj = unique([zoneList.relaxObj]);
            mergedList = DataUnit.empty;
            
            % merge all PP and NP acquisitions from similar files
%             filename = unique({relaxObj.filename});
            for i = 1:numel(relaxObj)
                filename{i}  = relaxObj(i).parameter.paramList.FILE; %#ok<AGROW>
            end
            refname = filename; % keep the initial list of names (filename is cropped at each iteration)
            
            while ~isempty(filename)
                indexMerge = strcmp(filename{1},refname);
                if sum(indexMerge)>1  % ignore files containing only one type of pulse sequences
                    
                    % make the merged item
                    datalist = getData(relaxObj(indexMerge), 'Zone');
                    mergedbloc = merge(datalist);
                    paramlist = [relaxObj(indexMerge).parameter];
                    mergedparam = merge(paramlist);
                    label = {relaxObj(indexMerge).label};
                    % add the merged item to the FitLike handle
                    mergedRelaxObj = RelaxObj('data',         mergedbloc,...
                                              'parameter',    mergedparam,...
                                              'label',        label{1},...
                                              'filename',     filename{1},...
                                              'sequence',     'Merged NP/PP zones',...
                                              'dataset',      getRelaxProp(datalist(1),'dataset'));
                    mergedbloc.relaxObj = mergedRelaxObj;
%                     fitlikeHandle.RelaxData(end+1) = mergedRelaxObj;
%                     addFile(fitlikeHandle.FileManager, mergedRelaxObj); % add the new object to the file manager
                    mergedRelaxObj.subRelaxObj = relaxObj(indexMerge); % keep the old objects to allow un-merge
                    
                    % add the merged object to the list
                    mergedList(end+1) = mergedbloc; %#ok<AGROW>
                    
                end
                % make sure we don't process a dataset twice
                indexDel = strcmp(filename{1},filename);
                filename(indexDel) = [];
                % select the new files instead of the old ones
                % TO DO
            end
            
        end %applyProcess
    end
end
