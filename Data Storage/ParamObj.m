classdef ParamObj < handle
    
    properties
        paramList@struct;   % list of parameters
    end
    
    methods 
         
        function self = ParamObj(paramStruct)
            % varargin should be a parameter structure, which is copied
            % into the paramlist field.
            if nargin > 0
                % if the input is an array of struct, then make an
                % array of objects
                if ~iscell(paramStruct)
                    for i = 1:length(paramStruct)
                        self(i).paramList = paramStruct;
                    end
                else
                    [self(1:length(paramStruct)).paramList] = deal(paramStruct{:}); 
                end
            end
        end
        
        % reshape the data in all fields according to the template provided
        function self = reshape(self,dim)
            fname = fields(self.paramList);
            for ind = 1:length(fname)
                val = getfield(self.paramList,fname{ind});
                if iscell(val) || isnumeric(val)
                    if (size(val,1)==dim(1) && size(val,2)==dim(2) && size(val,3)==dim(3))
                        val = reshape(val,dim);
                    end
                end
                self.paramList = setfield(self.paramList,fname{ind},val);
            end
        end
        
        % Syntax: val = getfield(self, 'field')
        %         val = getfield(self, 'field', 'ForceCellOutput', 'True')
        function value = getfield(self, field, varargin)
            % check if the field exist in all the parameter structures
            isfld = arrayfun(@(x) isfield(x.paramList,field), self);
            % check input size
            if length(self) > 1
                if all( isfld == 1) 
                    % get value
                    value = arrayfun(@(x) x.paramList.(field), self, 'UniformOutput',0);
                else
                    % initialise empty cell array
                    value = cell(1,length(self));
                    % fill what you can
                    value(isfld) = arrayfun(@(x) x.paramList.(field), self, 'UniformOutput',0);
                    % throw a warning
                    warning('getfield:MissingField',['One or more structure(s)'...
                                        ' miss the field required'])
                end
            else
                if isfld ~= 1
                    error('getfield:MissingField',['The required field does'...
                                         ' not exist'])
                else
                    if nargin > 2
                        if strcmp(varargin{1},'ForceCellOutput') &&...
                                strcmpi(varargin{2},'true')
                            value = {self.paramList.(field)};
                        elseif strcmpi(varargin{2},'false')
                            value = self.paramList.(field);
                        else
                            error('getfield:ForceCellOutput',['Wrong optional argument'...
                                          ' or value associated'])
                        end
                    else                           
                        value = self.paramList.(field);
                    end
                end
            end
        end %getfield

        
        function other = copy(self)
            other = ParamObj;
            other.paramList = self.paramList;
        end
        
        
        function self = setfield(self, field, value)
            if length(self) > 1 
                % check if the field exist in all the parameter structures
                isfld = arrayfun(@(x) isfield(x.paramList,field), self);
                % check the size of value
                if ~iscell(value) || length(value) ~= length(self)
                    error('setfield:WrongSizeInput',['The size of the value input'...
                        ' does not fit with the size of the array OR value input'...
                        'is not a cell'])
                end
                % because we are working with substructure, a for loop is
                % required
                if all(isfld ~= 1)
                    warning('setfield:MissingField',['One or more structure(s)'...
                                    ' miss the field required'])
                    self = self(isfld);
                    value = value(isfld);
                end
                % loop
                for i = 1:length(self)
                    self(i).paramList.(field) = value{i};
                end
            else
                % check if the field exist
                if ~isfield(self.paramList,field)
                    error('setfield:MissingField',['The field required does'...
                                          ' not exist'])
                else
                    self.paramList.(field) = value;
                end
            end
        end %setfield
        
        function self = changeFieldName(self,old,new)
            self.paramList  = setfield(self.paramList ,new,getfield(self,old));
            self.paramList = rmfield(self.paramList,old);
        end
        
        function self = merge(self,other)
            f2 = fieldnames(other.paramList);
            % place the exeptions here
            
            for indfname = 1:length(f2)
                fname = f2(indfname);
                fname = fname{1};
                val2 = getfield(other,fname);
                if isfield(self.paramList,fname)
                    val1 = getfield(self.paramList,fname);
                    try
                        if isnumeric(val1) && isnumeric(val2) %#ok<*GFLD>
                            self.paramList = setfield(self.paramList,fname,[val1,val2]); %#ok<*SFLD>
                        elseif iscell(val1) && iscell(val2)
                            self.paramList = setfield(self.paramList,fname,[val1,val2]);
                        else
                            self.paramList = setfield(self.paramList,fname,{val1,val2});
                        end
                    catch
                        self.paramList = setfield(self.paramList,fname,val2); % in case of an incompatibility, erase the old value altogether
                    end
                else
                    self.paramList = setfield(self.paramList,fname,val2);
                end
            end    
            % treat the exceptions here
            
        end
                
        function x = struct2cell(self)
            x = struct2cell(self.paramList);
        end
%         function x = getZoneAxis(self)
%         
%         end
%         
%         function x = getDispAxis(self)
%         
%         end
        
    end
end