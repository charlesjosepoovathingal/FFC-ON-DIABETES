classdef DataUnit < handle & matlab.mixin.Heterogeneous
    %
    % Abstract class that define container for all the Stelar SPINMASTER
    % relaxometer data (bloc, zone, dispersion).
    % DataUnit and its subclasses handle structure as well as array of
    % structure.
    % Notice that attributes for properties are defined directly avoiding
    % the need for further checking.
    %
    % SEE ALSO BLOC, ZONE, DISPERSION
    
    % file data
    properties (Access = public)
        x@double = [];          % main measure X (time, Bevo,...)
        xLabel@char = '';       % name of the  variable X ('time','Bevo',...)
        y@double = [];          % main measure Y ('R1','fid',...)
        dy@double = [];         % error bars on Y
        yLabel@char = '';       % name of the variable Y ('R1','fid',...)
        mask@logical = true(0);           % mask the X and Y arrays
        processingMethod@ProcessDataUnit;  % stores the processing objects that are associated with the data unit
    end   
    
    % file parameters
    properties (Access = public)
        parameter@ParamObj = ParamObj();       % list of parameters associated with the data
    end
    
    % file processing
    properties (Access = public)
        process@ProcessDataUnit = ProcessDataUnit(); % object use to process the data
    end
    
    % file properties
    properties (Access = public)
        filename@char = '';     % name of the file ('file1.sdf')
        sequence@char = '';     % name of the sequence ('IRCPMG')
        dataset@char = 'myDataset';      % name of the dataset('ISMRM2018')
        label@char = '0';        % label of the file ('control','tumour',...)
    end
    
    % other properties
    properties (Access = public, Hidden = true)
        fileID@char = '';       % ID of the file: [dataset sequence filename] 
        parent = [];            % parent of the object
        children = [];          % children of the object
    end
    
    methods 
        % Constructor: obj = DataUnit('field1',val1,'field2','val2',...)
        % DataUnit can build structure or array of structure depending on
        % the input:
        % x = num2cell(ones(10,1)); % array of cell
        % obj = DataUnit('x',x); % array of structure
        % obj = DataUnit('x',[x{:}]) % structure
        function obj = DataUnit(varargin)
            % check input, must be non empty and have always field/val
            % couple
            if nargin == 0 || mod(nargin,2) 
                % default value
                return
            end
            
            % check if array of struct
            if ~iscell(varargin{2})
                % struct
                for ind = 1:2:nargin
                    try 
                        obj.(varargin{ind}) = varargin{ind+1};
                    catch ME
                        error(['Wrong argument ''' varargin{ind} ''' or invalid value/attribute associated.'])
                    end                           
                end   
            else
                % array of struct
                % check for cell sizes
                n = length(varargin{2});
                if ~all(cellfun(@length,varargin(2:2:end)) == n)
                    error('Size input is not consistent for array of struct.')
                else
                    % initialise explicitely the array of object (required
                    % for heterogeneous array)
                    % for loop required to create unique handle.
                    for k = n:-1:1
                        % initialisation required to create unique handle!
                        obj(1,k) = DataUnit();
                        % fill arguments
                        for ind = 1:2:nargin 
                            [obj(k).(varargin{ind})] = varargin{ind+1}{k};                          
                        end
                    end
                end
            end   
            
            % generate mask if missing
            resetmask(obj);
            % generate fileID
            generateID(obj);
        end %DataUnit       
        
        
    end % methods
    
    methods (Access = public, Sealed = true)
        
        % Generate fileID field
        function obj = generateID(obj)
            if length(obj) > 1
                ID = strcat({obj.dataset}, {obj.sequence},...
                    {obj.filename},repmat({'@'},1,numel({obj.dataset})),...
                    {obj.displayName});
                [obj.fileID] = ID{:};            
            else
                obj.fileID = [obj.dataset, obj.sequence,...
                    obj.filename,'@', obj.displayName];
            end
        end %generateID
        
        % Fill or adapt the mask to the "y" field 
        function obj = resetmask(obj)
            % check if input is array of struct or just struct
            if length(obj) > 1 
                % array of struct
                idx = ~arrayfun(@(x) isequal(size(x.mask),size(x.y)), obj);
                % reset mask
                new_mask = arrayfun(@(x) true(size(x.y)),obj(idx),'UniformOutput',0);
                % set new mask
                [obj(idx).mask] = new_mask{:};
            else
                % struct
                if ~isequal(size(obj.mask),size(obj.y))
                    % reset mask
                    obj.mask = true(size(obj.y));
                end
            end
        end %resetmask       
    end %methods
     
%     methods (Access = public)
%         
%         function x = getZoneAxis(obj)
%             if size(obj) == 1
%                 x = getZoneAxis(obj.parameter);
%             else
%                 x = arrayfun(@(x) getZoneAxis(x.parameter),obj,'Uniform',0);
%             end
%         end %getZoneAxis
% 
%         function x = getDispAxis(obj)
%             if size(obj) == 1
%                 x = getDispAxis(obj.parameter);
%             else
%                 x = arrayfun(@(x) getDispAxis(x.parameter),obj,'Uniform',0);
%             end
%         end %getDispAxis
%     end %methods    
end

