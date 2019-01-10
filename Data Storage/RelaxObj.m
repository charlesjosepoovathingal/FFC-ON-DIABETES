classdef RelaxObj < handle
    % This class manage Stelar data from the SPINMASTER relaxometer.
    %
    % See also DATAUNIT, BLOC, ZONE, DISPERSION
    
    % file properties
    properties (Access = public)
        label@char = '';               % label of the file ('control','tumour',...)
        filename@char = '';            % name of the file ('file1.sdf')
        sequence@char = '';            % name of the sequence ('IRCPMG')
        dataset@char = 'myDataset';    % name of the dataset('ISMRM2018')
    end
    
    % data properties
    properties (Access = public)
        data@DataUnit
        parameter@ParamObj = ParamObj();  
    end  
    
    % ID and subfiles
    properties (Hidden)
        fileID@char;
        subRelaxObj@RelaxObj
    end
    
    
    events
        FileHasChanged
        FileIsDeleted
    end
    
    % Constructor/Destructor
    methods
        % Constructor: obj = RelaxObj('field1',val1,'field2','val2',...)
        % RelaxObj can build structure or array of structure depending on
        % the input:
        %
        % Example:
        % filename = {'file1','file2','file3'}; % cell array
        % obj = RelaxObj('filename',filename); % array of structure
        % obj = RelaxObj('filename',[filename{:}]) % structure
        %
        function this = RelaxObj(varargin)           
            % check input, must be non empty and have always field/val
            % couple
            if nargin == 0 || mod(nargin,2) 
                % default value
                return
            end
            
            % check if array of struct
            if ~iscell(varargin{2})                
                % fill the structure
                for ind = 1:2:nargin
                    this.(varargin{ind}) = varargin{ind+1};
                end 
                % add fileID
                this.fileID = char(java.util.UUID.randomUUID);
            else
                % array of struct
                % check for cell sizes
                n = length(varargin{2});
                for k = n:-1:1
                    % fill arguments
                    for ind = 1:2:nargin
                        [this(k).(varargin{ind})] = varargin{ind+1}{k};
                    end
                    % add fileID
                    this(k).fileID = char(java.util.UUID.randomUUID);
                end
            end
        end %RelaxObj
        
        % Destructor
        function delete(this)
           % call to the data 
           remove(this.data);
           % clear pointer
           this.data = [];
           % notify destruction
           notify(this,'FileIsDeleted');
        end
    end
    
    methods (Access = public)
        % Data formating: mergeFile()
        function obj = merge(obj_list)
            % check input
            if numel(obj_list) < 2
                return
            end
            % check if files are already merged
            switch isMerged(obj_list)
                case 0
                    % merge data and parameter
                    merged_data = merge([obj_list.data]);
                    merged_parameter = merge([obj_list.parameter]);
                    % create merged object from first object list
                    obj_list(1).data = merged_data;
                    obj_list(1).parameter = merged_parameter;
                    obj_list(1).subRelaxObj = obj_list;
                    obj = obj_list(1);
                case 1
                    % unmerge data and parameter
                    unmerged_data = merge([obj_list.data]);
                    unmerged_parameter = merge([obj_list.parameter]);
                    % create unmerged object
%                     obj_list(1).data = merged_data;
%                     obj_list(1).parameter = merged_parameter;
%                     obj = obj_list.subRelaxObj;
                otherwise
                    % mix of merged and unmerged files
                    return
            end
        end %mergeFile
    end
    
    % Data access functions
    methods (Access = public)
        % This function to get DataUnit object from the RelaxObj.
        %
        % Optionnal input: 
        % - 'class': char between {'Dispersion','Zone','Bloc'}
        % - 'name': char (corresponding to the displayName property in DataUnit
        %
        % Example:
        % data = getData(this); % Get all the data in RelaxObj
        %
        % data = getData(this, 'Dispersion'); % get all the Dispersion 
        % object in RelaxObj
        %
        % data = getData(this, 'Zone', 'Zone (Abs)')% get the zone object
        % in RelaxObj named 'Zone (Abs)'
        function data = getData(this, varargin)
            % check if data are available
            if isempty(this.data)
                data = []; return;
            end
            
            obj = this.data;
            % check if we need to find a particular type of object
            if nargin > 1                
                % find all the object corresponding to this class  || isempty(obj(1).children)
                while ~strcmpi(class(obj), varargin{1})
                    % check if parent are available
                    if  isempty(obj(1).parent)
                       error('No object was found with this class!') 
                    end
                    % get parent and remove duplicates
                    obj = unique([obj.parent]);
                end
                
                % check if we need to find a particular named obj
                if nargin > 2
                    tf = strcmp({obj.displayName}, varargin{2});
                    
                    if all(tf == 0)
                        error('No object was found with this name!')
                    else
                        data = obj(tf);
                    end
                else
                    data = obj;
                end
            else
                data = obj;
                % get all the object
                while ~isempty(obj(1).parent)
                    obj = unique([obj.parent]);
                    data = [data, obj]; %#ok<AGROW>
                end
            end
        end %getData
    end
end

