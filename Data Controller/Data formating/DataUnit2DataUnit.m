classdef DataUnit2DataUnit %< handle & matlab.mixin.Copyable [Manu]
    %
    % This class allows to format DataUnit for processing pipeline. Data
    % are formatted to fit with model requirements as well as making or 
    % modifying new Data Unit after processing step.
    %
    % see also BLOC2ZONE, ZONE2DISP, DATAUNIT, PROCESSDATAUNIT
    
    properties
        DataField = {'x','y','dy','mask'}; % define the field 
                                           % corresponding to data in DataUnit
        ForceDataCat@logical = false; %logical that forces data concatenation. 
                                      %Example: 
                                      % -false: Bloc() --> data_formated
                                      % is a BRLX x NBLK array of structure
                                      % where each field is 1xBS vector
                                      % -true: Bloc() --> data_formated
                                      % is a 1 x 1 array of structure
                                      % where each field is BS x NBLK x
                                      % BRLX matrix.
        ForceChildCreation@logical = false;  % force child creation when
                                            % parent DataUnit has children
                                            % with same class as the wanted
                                            % one for child creation.
%         pipeline = []; % for future use, handle to the pipeline object
%         InputData@DataUnit; % store the handle to the DataUnit object linked to the processing object
%         OutputData@DataUnit; % store the handle to the data generated
        ProcessData;        % process-generated data
    end
    
    properties (Access = private)
    end
    
    % Do not define these properties as Abstract because it will change
    % DataUnit2DataUnit as Abstract class [Manu]
    properties (Abstract)
        InputChildClass@char
        OutputChildClass@char %define the class of the child object
    end
    
    methods
        % Constructor
        function this = DataUnit2DataUnit()
            
        end %DataUnit2DataUnit
                
        % Format DataUnit data in an array of structure with the following
        % field: x, y, dy, mask (See DataUnit property).
        % Dimension of the array of structure depends on the input class:
        % - Bloc: data_formated is a NBLK x BRLX array of struct where each
        %         field is a BS x 1 vector
        % - Zone: data_formated is a BRLX x 1 array of struct where each
        %         field is a NBLK x 1 vector
        % - Dispersion: data_formated is a 1 x 1 array of struct where each
        %         field is a BRLX x 1 vector
        % 
        % If ForceDataCat property is set to true data_formated will be a
        % 1 x 1 structure where each field has the same size than the input
        % class:
        % Bloc: BS x NBLK x BRLX
        % Zone: NBLK x BRLX
        % Dispersion: BRLX x 1
        %
        function data_formated = getProcessData(this, DataUnit)
            % check input
            if ~isa(DataUnit,'DataUnit')
                data_formated = []; return
            end
            if length(this)>1
                data_formated = arrayfun(@(t) getProcessData(t, DataUnit),this,'UniformOutput',0);
                data_formated = [data_formated{:}];
                return
            end
            
            % get data dim
            dim = size(DataUnit.y);
            
            % cast dim in 3D
            if numel(dim) < 3; dim(3) = 1; end
                            
            % check if ForceDataCat is true
            if this.ForceDataCat
                % get data as is and prepare struct input
                for k = numel(this.DataField):-1:1
                    % field
                    varargin{2*k-1} = this.DataField{k}; 
                    % data
                    varargin{2*k} = DataUnit2DataUnit.checkSize(DataUnit.(this.DataField{k}), dim);
                end
                % create struct
                data_formated = struct(varargin{:});
            else
                % init to force appropriate orientation
                C = cell(numel(this.DataField), dim(2), dim(3));
                % loop over the field
                for k = 1:numel(this.DataField)
                    % get data
                    data = DataUnit2DataUnit.checkSize(DataUnit.(this.DataField{k}), dim);
                    % convert data to cell array
                    C(k,:,:) = mat2cell(data,...
                        dim(1),repelem(1,dim(2)),repelem(1,dim(3)));
                end
                % convert to array of struct
                data_formated = cell2struct(C, this.DataField, 1);
            end
        end %getProcessData    
        
        % Format processed data to make new DataUnit object. Input size
        % need to respect the following format from getProcessData output
        % if the ForceDataCat flag is set to false:
        % - Bloc: data_formated is a NBLK x BRLX array of struct where each
        %         field is a (BS,1) x N vector
        % - Zone: data_formated is a BRLX x 1 array of struct where each
        %         field is a (NBLK,1) x N vector
        % - Dispersion: data_formated is a 1 x 1 array of struct where each
        %         field is a (BRLX,1) x N vector
        %
        % N is the number of object to create (Biexp: 2 object, Monoexp: 1
        % obj,...)
        % (BS,1): can take these two values. If Dispersion is filtered, it
        % will returned the same size object 1 x BRLX. On the other hand,
        % if Zone is fitted with Monoexp, each field will be 1 x 1 (T1).
        % 
        % If ForceDataCat flag is set to true, input data_formated should
        % be a 1 x N array of structure (N object to create) where each
        % field is already well formated:
        % - Bloc should be BS x NBLK x BRLX
        % - Zone should be NBLK x BRLX
        % - Dispersion should be BRLX x 1
        %
        function DataUnit_child = makeProcessData(this, data_formated, DataUnit_parent)
            % check input
            if ~isa(DataUnit_parent,'DataUnit')
                DataUnit_child = []; return
            end
            
            % if no data, return parent object
            if isempty(data_formated); DataUnit_child = DataUnit_parent; return; end
            
            % get fieldnames and number of object and init data
            fld = fieldnames(data_formated);
            data = cell(1,2*numel(fld)); data(1:2:end) = fld;
            
            % check if ForceDataCat is true
            if this.ForceDataCat
                % get number of object to create
                n = numel(data_formated); 
                data_formated = struct2cell(data_formated);
                % loop over the field
                for k = numel(fld):-1:1
                    % get data and convert to 1xn cell array
                    data{2*k} = squeeze(data_formated(k,:,:));               
                end                
            else
                %number of object to create
                n = size(data_formated(1,1).(fld{1}),2); 
                % check if output data are singleton along first dimension. If
                % not, data were just modified and not converted into a new
                % class (filtering,...).
                if size(data_formated(1,1).(fld{1}),1) > 1
                    dim = [size(data_formated(1,1).(fld{1}),1), size(data_formated), n];
                else
                    dim = [size(data_formated), n];
                end
                % loop over the field
                for k = numel(fld):-1:1
                    % if NaN are in the data, it changes the concatenation 
                    if all(any(isnan(vertcat(data_formated.(fld{k}))) == 0) == 0)
                        val = horzcat(data_formated.(fld{k}))';
                    else
                        val = vertcat(data_formated.(fld{k}));
                    end
                    val = reshape(val, dim);
                    % convert into 1xn cell array
                    data{2*k} = squeeze(num2cell(val,1:numel(size(val))-1));
                end
            end
            % get the output class
            fh = str2func(this.OutputChildClass);
            
            if isempty(DataUnit_parent.children)
                % create child DataUnit
                DataUnit_child = fh('parent',repmat({DataUnit_parent},1,n), data{:});
            else
                % check the class of parent's children class and if the
                % same and flag is false update the parent's children
                % object. Else delete children.
                if strcmp(this.OutputChildClass, class(DataUnit_parent.children)) &&...
                        ~this.ForceChildCreation
                   % count children and create/delete/update in function
                   DataUnit_child = DataUnit_parent.children;
                   nChild = numel(DataUnit_child);
                   if nChild < n
                       % loop over the field
                       for k = 1:numel(fld)
                           % get data and fill children
                           val = data{2*k}(1:nChild);
                           [DataUnit_child.(fld{k})] = val{:};
                           % remove used data
                           data{2*k} = data{2*k}(nChild+1:end);
                       end
                       % add new data
                       DataUnit_child = [DataUnit_child, fh('parent',...
                           repmat({DataUnit_parent},1,n-nChild), data{:})];
                   elseif nChild > n
                       % remove some children
                       DataUnit_child = remove(DataUnit_child, 1:nChild-n);
                       % update data
                       for k = 1:numel(fld)
                           [DataUnit_child.(fld{k})] = data{2*k}{:};
                       end
                   else
                       % update data
                       for k = 1:numel(fld)
                           [DataUnit_child.(fld{k})] = data{2*k}{:};
                       end    
                   end
                else
                   % delete all the children of parent
                   DataUnit_parent.children = remove(DataUnit_parent.children);
                   % create child DataUnit
                   DataUnit_child = fh('parent',repmat({DataUnit_parent},1,n), data{:});
                end
            end
        end %makeProcessData
        
        % Simple function that format output data from applyProcess
        function data = formatData(this, data)
            % get dim
            dim = size(data);
            data = [data{:}];
            % check input
            if isempty(data); return; end
            % uncell and reshape
            data = reshape(data, dim);
        end %formatData
        
        % add a DataUnit object to the list of data to be processed (and
        % check for duplicates). Works with arrays too.
        function this = addInputData(this,dataUnit)
            if length(this)>1
                this = arrayfun(@(t) addInputData(t,dataUnit),this);
            else
                % check input type
                if ~isequal(class(dataUnit),this.InputChildClass)
                    error(['Wrong data input type , is ' class(dataToProcess) ' when expecting ' this.InputChildClass '.'])
                else
                    if isempty(this.InputData)
                        this.InputData = dataUnit;
                    elseif ~prod(arrayfun(@(d) isequal(d,dataUnit),this.InputData)) % check that the data is not already contained
                        this.InputData(end+1) = dataUnit;
                    end
                end
            end
        end
        
        % remove an array of DataUnit object from the list of data to be
        % processed (if they are present)
        function this = removeInputData(this,dataUnit)
            if length(this)>1
                this = arrayfun(@(t) removeInputData(t,dataUnit),this);
            else
                for i = 1:length(dataUnit)
                    ind = isequal(this.InputData,dataUnit(i));
                    this.InputData(ind) = [];
                end
            end
        end
        
        % returns the list of input data (in case the property is hidden)
        function dataList = checkInputData(this)
            dataList = this.InputData;
        end
        
        % returns the list of output data (in case the property is hidden)
        function dataList = checkOutputData(this)
            dataList = this.OutputData;
        end
%         
%         function removeInputData(this,dataUnit)
%             for i = 1:length(dataUnit)
%                 index = arrayfun(@(d) isequal(d,dataUnit(i)),this.InputData);
%                 this.InputData(index) = [];
%             end
%         end
        
%         Avoid method's name problem (applyProcess if defined in the model
%         itself) [Manu]
%         % applies a model (element or array) to relaxObject (element or
%         % array). This function simplifies data processing by allowing
%         % selection by DataUnit name or by pulse sequence name.
%         function processList = applyProcess(this,relax,varargin)
%             % check that only one processing object is used, otherwise
%             % recursively process each case
%             if length(this)>1
%                 processList = arrayFun(@(t) applyProcess(t,relax,varargin{:}),this,'UniformOutput',0);
%                 return
%             end
%             
%             if nargin<2 % case when the process is already assigned, it just needs to update its output
%                 processList = processData(this);
%                 return
%             end
%             
%             % case when DataUnits are provided: pass the process to the
%             % DataUnit object (this case should not be used)
%             sc = superclasses(relax);
%             if isequal(sc{1},'DataUnit')
%                 [relax,processList] = assignProcessingFunction(relax,this);
%                 [childDataUnit,relax] = processData(relax);
%                 return
%             end
%             
%             % here, only one process is selected. It may be applied to
%             % several RelaxObjects, and to several DataUnit within the each
%             % RelaxObject. Selections are done using the type of pulse
%             % sequence from RelaxObj or the type of displayName from
%             % DataUnit.
%             % start by setting the default case, then checks the inputs and
%             % overwrite them
%             indexDataUnit = arrayfun(@(r) arrayfun(@(d) isequal(class(d),this.InputChildClass),r.data), relax, 'UniformOutput',0); % cell array, contains the dataUnit selection for each relaObj
%             indexRelaxObj = true(1,length(relax));  % selection of the valid relaxObjects
%             for i = 1:2:length(varargin)
%                 switch varargin{i}
%                     case 'sequence'
%                         indexRelaxObj = indexRelaxObj & arrayfun(@(o) isequal(o.sequence,varargin{i+1}), relax);
%                     otherwise % case of an arbitrary property of DataUnit (such as 'displayName')
%                         for j = 1:length(indexDataUnit)
%                             indexDataUnit{j} = indexDataUnit{j} & arrayfun(@(o) isequal(getRelaxProp(o,varargin{i}),varargin{i+1}), relax(j).data);
%                         end
%                 end               
%             end
%             
%             % launch the processing for each RelaxObj
%             for indRelax = 1:length(relax)
%                 if indexRelaxObj(indRelax)
%                     if sum(indexDataUnit{indRelax}) % make sure at least one dataUnit is to be processed within the RelaxObj
%                         [dataUnitList,processList] = assignProcessingFunction([relax(indRelax).data(indexDataUnit{indRelax})],this); %#ok<NBRAK>
%                         [processList,dataProcessed,dataToProcess] = processData(processList);
%                     end
%                 end
%             end
%         end

        
        % Avoid method's name problem: ProcessDataUnit defines already this
        % method [Manu]
        % standard naming convention for the processing function
        % Inputs: 
        %   this: array of processing objects
        %   dataToProcess: single DataUnit element

%         function [this,dataProcessed,dataToProcess] = processData(this)
%             % distribute the algorithms defined in the process object (which
%             % inherits from DataUnit2DataUnit and DataModel)
%             [out,in] = arrayfun(@(s)applyProcessFunction(s),this,'UniformOutput',0);
%             % parse outputs
%             dataProcessed = [out{:}];
%             dataToProcess = [in{:}];
%             % check output type
%             if ~isequal(class(dataProcessed),this.OutputChildClass)
%                 error(['Wrong data input type , is ' class(dataToProcess) ' when expecting ' this.OutputChildClass '.'])
%             end
%         end
        

%         function [this,dataProcessed,dataToProcess] = processData(this)
%             % distribute the algorithms defined in the process object (which
%             % inherits from DataUnit2DataUnit and DataModel)
%             [out,in] = arrayfun(@(s)applyProcessFunction(s),this,'UniformOutput',0);
%             % parse outputs
%             dataProcessed = [out{:}];
%             dataToProcess = [in{:}];
%             % check output type
%             if ~isequal(class(dataProcessed),this.OutputChildClass)
%                 error(['Wrong data input type , is ' class(dataToProcess) ' when expecting ' this.OutputChildClass '.'])
%             end
%         end
                
        % function that applies one processing function to one bloc only.
        % This is where the custom processing function is being called.
        function [outputdata,inputdata] = applyProcessFunction(this)  
            
            sze = size(this.InputData.y);
            if length(sze)<3
                sze(3) = 1;   % make sure the data is interpreted as a 3D matrix
            end
            % prepare the cell arrays, making sure the dimensions are
            % consistent
            cellx = squeeze(num2cell(this.InputData.x,1));
            celly = squeeze(num2cell(this.InputData.y,1));
            % make sure the data is sorted
            [cellx,ord] = cellfun(@(c)sort(c),cellx,'UniformOutput',0);
            celly = cellfun(@(c,o)c(o),celly,ord,'UniformOutput',0);
            % cast to cell array for cellfun
%             cellindex = repmat(num2cell(1:this.InputData.parameter.paramList.NBLK)',1,size(this.InputData.y,3));
            if isempty(this.InputData.y)
                z = [];
                dz = [];
                this.ProcessData = {};
            else
                for i = 1:getRelaxProp(this.InputData, 'NBLK')                
                    for j = 1:size(this.InputData.y,3)
                        cellindex{i,j} = [i,j]; %#ok<AGROW>
                    end
                end
                if ~isequal(size(cellindex),size(cellx))
                    cellx = cellx';
                    celly = celly';
                end
                % make sure that each acquisition is referenced from the time
                % of acquisition within the data this.InputData
                cellx = cellfun(@(x)x-x(1),cellx,'UniformOutput',0);
                % process the cell array to get the this.OutputData data
                [z, dz, this.ProcessData] = cellfun(@(x,y,i) process(this,x,y,this.InputData,i),cellx,celly,cellindex,'Uniform',0);
                szeout = size(z{1,1});
                [szeout,ind] = max(szeout); 
                if ind == 2 % check that the result of the process is a column array
                    z = reshape(cell2mat(z),sze(2),szeout,sze(3));
                    dz = reshape(cell2mat(dz),sze(2),szeout,sze(3));
                else
                    z = reshape(cell2mat(z),szeout,sze(2),sze(3));
                    z = permute(z,[2 1 3]);
                    dz = reshape(cell2mat(dz),szeout,sze(2),sze(3));
                    dz = permute(dz,[2 1 3]);
                end
            end
            
            % generate one this.OutputData object for each component provided by the
            % processing algorithm
            warning('off','MATLAB:mat2cell:TrailingUnityVectorArgRemoved') % avoid spamming the terminal when the data is not multiexponential
            cellz = mat2cell(z,size(z,1),ones(1,size(z,2)),size(z,3));
            celldz = mat2cell(dz,size(dz,1),ones(1,size(dz,2)),size(dz,3));
            cellz = cellfun(@(x) squeeze(x),cellz,'UniformOutput',0);
            celldz = cellfun(@(x) squeeze(x),celldz,'UniformOutput',0);
            x = getZoneAxis(this.InputData); % raw x-axis (needs to be repmat to fit the dimension of y)
            x = repmat(x,size(cellz)); % make sure that all cell arrays are consistent
%             params = repmat({params},size(cellz));
            labelX = repmat({this.labelX},size(cellz));
            labelY = repmat({this.labelY},size(cellz));
            if numel(this.legendTag) ~= numel(labelX)
                legendTag = repmat(this.legendTag,size(cellz));
            else
                legendTag = this.legendTag;
            end
            
            % generate the children objects if they are not yet created
            if isempty(this.OutputData)
                this.OutputData = Zone('parent',repmat({this.InputData},size(celldz)),...
                                       'x',x,'xLabel',labelX,...
                                       'y',cellz,'dy',celldz,'yLabel',labelY,...
                                       'legendTag',legendTag,...
                                       'relaxObj',this.InputData.relaxObj);
            else % if a child object is there, just update it
                this.OutputData = arrayfun(@(z,lx,cz,cdz,ly,l) updateProperties(z,...
                                            'xLabel',lx,...
                                            'y',cz,'dy',cdz,'yLabel',ly,...
                                            'legendTag',l),...
                                            this.OutputData,labelX,cellz,celldz,labelY,legendTag);
            end
            outputdata = this.OutputData;
            inputdata = this.InputData;
        end


        
    end
    
    methods (Static)        
        % Check if a matrix corresponds to a given size. If false, complete
        % the matrix with NaN to get the final matrix
        function data_checked = checkSize(data, dim)
            % check size
            s = size(data);
            
            % cast size in 3D
            if numel(s) < 3; s(3) = 1; end
            
            % check size and complete with NaN if required
            if isequal(s, dim)
                data_checked = data;
                return
            elseif isempty(data)
                data_checked = nan(dim);
            else
                data_checked = nan(dim);
                data_checked(1:s(1),1:s(2),1:s(3)) = data;
            end
        end %checkSize   
    end
    
    
%     methods (Abstract)
%         
%         % test the compatibility between the processing object and the
%         % input data
%         function out = testDataFormat(self)
%         end
%     end
    
end

