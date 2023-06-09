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
    properties (Access = public, SetObservable, AbortSet)
        x@double = [];              % main measure X (time, Bevo,...)
        y@double = [];              % main measure Y ('R1','fid',...)
        dy@double = [];             % error bars on Y
        mask@logical = true(0);     % mask the X and Y arrays
        xLabel@char = '';           % name of the  variable X ('time','Bevo',...)
        yLabel@char = '';           % name of the variable Y ('R1','fid',...)
    end   
    
    % file processing
    properties (Access = public, SetObservable)
        processingMethod; % @(DataUnit2DataUnit & ProcessDataUnit); % stores the processing objects that are associated with the data unit (cannot declare mixed class types)
    end
    
    % meta-data
    properties (Access = public)
        legendTag@char = '';
        displayName@char = '';  % char array to place in the legend associated with the data (should be protected)
    end
    
    % other properties
    properties (Hidden = true)
        relaxObj@RelaxObj        % handle to the meta-data
        parent@DataUnit          % parent of the object
        children@DataUnit        % children of the object
        parameters@ParamObj;     % redirects towards relaxobj parameters
        subUnitList@DataUnit;    % lists the data that were merged to create this object, if any
    end
    
    events
        DataDeletion
        DataUpdate
    end
    
    methods 
        % Constructor: obj = DataUnit('field1',val1,'field2','val2',...)
        % DataUnit can build structure or array of structure depending on
        % the input:
        % x = num2cell(ones(10,1)); % array of cell
        % obj = DataUnit('x',x); % array of structure
        % obj = DataUnit('x',[x{:}]) % structure
        function this = DataUnit(varargin)
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
                    this.(varargin{ind}) = varargin{ind+1};                         
                end 
                % parent explicitely the object if needed
                if ~isempty(this.parent)
                    link(this.parent, this);
                    this.relaxObj = this.parent.relaxObj;
                    % check x-values
                    if isempty(this.x)
                        this.x = getXData(this);
                    end
                end
                % check mask
                if isempty(this.mask) || ~isequal(size(this.mask), size(this.y))
                    this.mask = true(size(this.y));
                end
                % set displayName
                setname(this);
            else
                % array of struct
                % check for cell sizes
                n = length(varargin{2});
                if ~all(cellfun(@length,varargin(2:2:end)) == n)
                    error('Size input is not consistent for array of struct.')
                else
                    fh = str2func(class(this));
                    % initialise explicitely the array of object (required
                    % for heterogeneous array)
                    % for loop required to create unique handle.
                    for k = n:-1:1
                        % initialisation required to create unique handle
                        this(1,k) = fh();
                        % fill arguments
                        for ind = 1:2:nargin 
                            if iscell(varargin{ind+1})
                                [this(k).(varargin{ind})] = varargin{ind+1}{k}; 
                            else
                                [this(k).(varargin{ind})] = varargin{ind+1}(k);                          
                            end
                        end
                        % declare explicitely the parent object if needed
                        if ~isempty(this(k).parent)
                            link(this(k).parent, this(k));
                            this(k).relaxObj = this(k).parent.relaxObj;
                            % check x-values
                            if isempty(this(k).x)
                                this(k).x = getXData(this(k));
                            end
                        end
                        % check mask
                        if isempty(this(k).mask) ||...
                                ~isequal(size(this(k).mask), size(this(k).y))
                            this(k).mask = true(size(this(k).y));
                        end
                        % set displayName
                        setname(this(k));
                    end
                end
            end   
        end %DataUnit    
        
        % Destructor
        function delete(this)
            % notify the deletion
            notify(this, 'DataDeletion');
            % if relaxObj, remove handle
            if ~isempty(this.relaxObj)
                tf = ~arrayfun(@(d) isequal(d, this),this.relaxObj.data);
                this.relaxObj.data = this.relaxObj.data(tf);
            end
            % unlink
            unlink(this);
            % delete children if required
            delete(this.children);
            this.children(:) = [];
            this.parent(:) = [];
        end
    end
    
    methods (Access = public)
        
        % Should be in Pipeline [Manu]
        function [this,processObj] = addprocess(this,processObj)
            if isempty(this.processingMethod)
                this.processingMethod = processObj;
            else
                this.processingMethod(end+1) = processObj;
            end
        end
        
%         % assign a processing function to the data object
%         function [this,processList] = assignProcessingFunction(this,processObj)
% %             [this,processList] = arrayfun(@(s)addprocess(s,copy(processObj)),this,'UniformOutput',0); %#ok<*SFLD> associate the data and the processing method
%             [this,processList] = arrayfun(@(s)addprocess(s,processObj),this,'UniformOutput',0); %#ok<*SFLD> associate the data and the processing method
%             this = [this{:}];   
%             processList = [processList{:}];
% %             processList = arrayfun(@(s) addInputData(processList,s),this,'UniformOutput',1); % associate each data unit with its processing method
%         end %assignProcessingFunction

        % Should be in Pipeline [Manu]
        % remove or clear a list of processing functions for a given
        % object or list of objects
        function this = removeProcessingFunction(this,processObj)
            if nargin < 2
                this = arrayfun(@(d) setfield(d,'processingMethod', []),this);
            else
                for ind = 1:length(processObj)
                    index = arrayfun(@(d) isequal(d.processingMethod,processObj(ind)),this,'UniformOutput',0);
                end
                this = arrayfun(@(d,i) setfield(d,'processingMethod', d.processingMethod(i)),this,index);
            end
        end
        
        % removal from the parent object list for clean deletion
        function unlink(this)
            if length(this)>1
                arrayfun(@(o)unlink(o),this,'UniformOutput',0)
            else
                for i = 1:length([this.parent])
                    ind = arrayfun(@(o)isequal(o,this),this.parent(i).children);
                    this.parent(i).children(ind) = [];
                end
                for i = 1:length([this.children])
                    ind = arrayfun(@(o)isequal(o,this),this.children(i).parent);
                    this.children(i).parent(ind) = [];
                end
            end
        end %unlink
        
        % dummy function to get x-values (redefined in subclasses)
        function x = getXData(this) 
            x = [];
        end %getXData

%         % wrapper function to start the processing of the data unit
%         function [childDataUnit,this] = processData(this)
%             if sum(arrayfun(@(s)isempty(s.processingMethod),this))
%                 error('One or more data object are not assigned to a processing function.')
%             end
%             [childDataUnit,~] = arrayfun(@(o)processData(o.processingMethod, o),this,'UniformOutput',0); % If called from here, processData processes each DataUnit objects one by one
%             childDataUnit = [childDataUnit{:}];
% %             [this.processingMethod] = deal(processMethod);
%         end        
        
        % wrapper function to start the processing of the data unit
        function [childDataUnit,this] = processData(this, processObj)
            % check input
            if ~isa(processObj, 'ProcessDataUnit')
                childDataUnit = []; return
            end
            % processData processes each DataUnit objects one by one
            [childDataUnit, ~] = arrayfun(@(o)processData(processObj, o),...
                this,'UniformOutput',0);
            childDataUnit = [childDataUnit{:}];
        end  
        
        % collect the display names from all the parents in order to get
        % the entire history of the processing chain, for precise legends
        function legendStr = collectLegend(this)
            legendStr = this.legendTag;
            if ~isempty(this.parent)
                legendStr = [legendStr ', ' collectLegend(this.parent)];
            end
        end %collectLegend
        
        % make a copy of an object
        function other = copy(this)
            fh = str2func(class(this));
            other = fh();
            fld = fields(this);
            for ind = 1:length(fld)
                other.(fld{ind}) = this.(fld{ind});
            end
        end %copy

        % merging function, merges a list of the same data object type
        function mergedUnit = merge(selfList)
            % check that object are homonegeous
            fh = str2func(class(selfList));
            if strcmp(fh, 'DataUnit')
                mergedUnit = [];
                return
            else
                % call constructor with the first merged filename (avoid
                % returning null object)
%                 mergedUnit = fh('filename',[selfList(1).filename,' (merged)'],...
%                                 'sequence',selfList(1).sequence,'dataset',...
%                                 selfList(1).dataset, 'displayName',...
%                                 selfList(1).displayName,'legendTag',...
%                                 selfList(1).legendTag,'xLabel',...
%                                 selfList(1).xLabel,'yLabel',...
%                                 selfList(1).yLabel);
                mergedUnit = fh('displayName',   selfList(1).displayName,...
                                'legendTag',     selfList(1).legendTag,...
                                'xLabel',        selfList(1).xLabel,...
                                'yLabel',        selfList(1).yLabel);
                mergedUnit.subUnitList = selfList;
            end
        end

%         % reverse operation 
%         function dataList = unMerge(self)
%             dataList = self.subUnitList;
%             delete(self.subUnitList);
%         end

    end % methods
    
    methods (Access = public, Sealed = true)  
        % remove dataunit 
        function this = remove(this, idx)
            % check input
            if nargin < 2
                idx = 1:numel(this);
            end
            % remove properly DataUnit
            for k = 1:numel(idx)
                delete(this(idx(k)));
            end
            % remove deleted handle
            this = this(setdiff(1:numel(this),idx));
        end
        
        % this function will check the array of object to ensure that no
        % invalid handles (deleted) are presented. Invalid handles are
        % deleted.
        function this = checkHandle(this)
            % check input
            if isempty(this); return; end
            
            % start by remove invalid data
            this = this(isvalid(this));
            
            % loop over the input
            for k = 1:numel(this)
                % check the parent/children property
                this(k).children = this(k).children(isvalid(this(k).children));
                this(k).parent = this(k).parent(isvalid(this(k).parent));
                
                % check the relaxObj handle
                tf = ~isempty(this(k).relaxObj);
                this(k).relaxObj = this(k).relaxObj(isvalid(this(k).relaxObj));
                
                % throw warning if no relaxObj
                if isempty(this(k).relaxObj) && tf
                    warning('DataUnit: checkHandle: no relaxObj handle detected')
                end
                
                % if subDataUnit, call the function recursively
                if ~isempty(this(k).subUnitList)
                    this(k).subUnitList = checkHandle(this(k).subUnitList);
                end
            end %for loop
        end %checkHandle
        
        % link parent and children units
        function [parentObj, childObj] = link(parentObj, childObj)
            for indp = 1:length(parentObj)              
                for indc = 1:length(childObj)
                    % check that the children objects are not already listed in the
                    % parent object
                    if ~sum(isequal(childObj(indc).parent,parentObj(indp)))
                        childObj(indc).parent(end+1) = parentObj(indp);
                    end
                    % check that the children objects are not already listed in the
                    % parent object
                    if ~sum(isequal(parentObj(indp).children,childObj(indc)))
                        parentObj(indp).children(end+1) = childObj(indc);
                    end
                end
           end         
        end %link
        
        
        % Wrapper to get data from DataUnit
        function [x,y,dy,mask] = getData(this, idxZone)
            % call dimension indexing function
            dim = getDim(this, idxZone);
            % get data
            x = this.x(dim{:}); y = this.y(dim{:});
            dy = this.dy(dim{:}); mask = this.mask(dim{:});
        end % getData
        
        % Set mask according to a [x,y] range. the new mask is added to the
        % current mask. Can be called with only two input to reset the mask.
        function this = setMask(this, idxZone, xrange, yrange)
            % call dimension indexing function
            dim = getDim(this, idxZone);
            
            % check input: if no range, reset mask
            if nargin < 3
                this.mask(dim{:}) = true(size(this.mask(dim{:})));
            else
                % get the range
                range = ((xrange(1) < this.x(dim{:}) & this.x(dim{:}) < xrange(2))&...
                        (yrange(1) < this.y(dim{:}) & this.y(dim{:}) < yrange(2)));
                % invert the mask according to the range
                this.mask(dim{:}(range)) = ~this.mask(dim{:}(range));
            end
        end %setMask
        
        % Wrapper to get RelaxObj property from DataUnit
        function val = getRelaxProp(this, prop)
            
            % treat multiple inputs recursively
            if numel(this)>1
               val = arrayfun(@(t) getRelaxProp(t, prop),this,'UniformOutput',false);
                return
            end
            
            % check if RelaxObj exists
            if isempty(this.relaxObj)
                val = []; return;
            end
            
            % try/catch. If not another solution could be the use of
            % RelaxObj's method to get the complete list of property
            % (including hidden ones!) to check 'prop' before the call
            % [Manu]
            try
                val = this.relaxObj.(prop);
            catch
                error('getRelaxProp: Unknown property') % give up the search
            end
        end %get.meta
        
        % update an existing data set with new properties
        function this = updateProperties(this,varargin)
            fieldName = varargin(1:2:end);
            value = varargin(2:2:end);
            selfcell = mat2cell(this(:)',1,ones(1,length(this)));
            for nf = 1:length(fieldName)
                if ~iscell(value{nf})
                    value{nf} = repmat(value(nf),1,length(this));
                elseif length(value{nf}) == 1
                    value{nf} = repmat(value{nf},1,length(this));
                end
                selfcell = cellfun(@(obj,value) setfield(obj,fieldName{nf},value),selfcell,value{nf},'UniformOutput',0);
            end
            this = [selfcell{:}];
        end %updateProperties
        
        % set displayName following this rule:
        % [class(obj) obj.legendTag (obj.parent.legendTag,
        % obj.parent.parent.legendTag, ...)]
        function this = setname(this)
%             % check if existing displayName
%             if ~isempty(this.displayName); return; end

            % init
            if isempty(this.legendTag)
                this.displayName = class(this);
            else
                this.displayName = [class(this),' ',this.legendTag];
            end
            
            % loop over the parent to get additional information
            if ~isempty(this.parent)
                if ~isempty(this.parent.legendTag)
                    parentTag = collectLegend(this.parent);
                    this.displayName = [this.displayName,' (',...
                                            parentTag(1:end-2),')'];
                end
            end     
        end %setname
        
        % plot data function
        function h = plotData(this, idxZone, varargin)
            % get data
            [xp,yp,~,maskp] = getData(this, idxZone);
            % check if legend is required
            if all(strcmp('DisplayName',varargin) == 0)
                varargin{end+1} = 'DisplayName';
                varargin{end+1} = getLegend(this, idxZone, 'Data', 0);
            end
            % plot
            if ~isempty(yp(maskp))
                h = errorbar(xp(maskp), yp(maskp), [], varargin{:}); 
            else
                h = [];
            end
            % check if parent. Add axis label and title if false.
            if all(strcmp('Parent',varargin) == 0)
                xlabel(this.xLabel)
                ylabel(this.yLabel)
                legend('show')
                set(get(gca,'Legend'),'Interpreter','none');
                set(gca,'XScale','log')
            end
         end %plotData
         
         % Add error to an existing errorbar. 
         function h = addError(this, idxZone, h)
             % get data
             [~,~,dyp, maskp] = getData(this, idxZone);
             % plot
             set(h, 'YNegativeDelta',-dyp(maskp), 'YPositiveDelta',dyp(maskp));
         end %addError
         
         % Plot Masked data
         function h = plotMaskedData(this, idxZone, varargin)
             % get data
             [xp,yp,~,maskp] = getData(this, idxZone);
             % check if data to plot
             if ~isempty(yp(~maskp))
                 % plot
                 h = plot(xp(~maskp), yp(~maskp), varargin{:});
                 % remove this plot from legend
                 set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
             else
                 h = [];
             end
         end %plotMaskedData
         
         % Plot Fit
         function h = plotFit(this, idxZone, varargin)
             % get data
             [xfit, yfit] = getFit(this, idxZone, []);
             % check if possible to plot fit
             if ~isempty(yfit)
                 % check if legend is required
                 if all(strcmp('DisplayName',varargin) == 0)
                     varargin{end+1} = 'DisplayName';
                     varargin{end+1} = getLegend(this, idxZone, 'Fit', 0);
                 end
                 % plot
                 h = plot(xfit, yfit,varargin{:});
             else
                 h = [];
             end
         end %plotFit
         
         % Plot Residual
         function h = plotResidual(this, idxZone, varargin)
              % get data
              [xr,yr,~,maskr] = getData(this, idxZone);
              [~, yfit] = getFit(this, idxZone, xr(maskr));
             % check if possible to plot fit
             if ~isempty(yfit) && ~isempty(yr)
                 h = plot(xr(maskr), yr(maskr) - yfit, varargin{:});
             else
                 h = [];
             end
         end %plotResidual
        %%% -------------------------------------------- %%%
    end %methods
 
    % The methods described below are used to enable the merge capabilities
    % of the DataUnit object. They work by re-directing any quiry for the
    % x, y, dy and mask fields towards the list of sub-objects. Any
    % modification in here must take care to avoid recursive calls and to
    % limit the processing time, as these fields are used extensively
    % during processing.
    % LB 20/08/2018
    methods
        % make sure that any link to a relax object updates the object in
        % question
        function set.relaxObj(this, relax)
            add(relax, this);
            this.relaxObj = relax;
        end
        
        % set legendTag update the displayName
        function this = set.legendTag(this, val)
            % add legendTag and update displayName
            this.legendTag = val;
            setname(this);
        end
       
%        % set y-values
%        function self = set.y(self,value)
% %            if ~isempty(self.subUnitList)
% %                % distribute the values to the sub-units
% %                self = distributeSubData(self,'y',value);
% %            end
%             % check if different from before
%             self.y = value;
%        end
%        
%        % set x-values
%        function self = set.dy(self,value)
% %            if ~isempty(self.subUnitList)
% %                % distribute the values to the sub-units
% %                self = distributeSubData(self,'dy',value);
% %            end
%            self.dy = value;
%        end
%        
%        % set mask
%        function self = set.mask(self,value)
% %             if ~isempty(self.subUnitList) %#ok<*MCSUP>
% %                 % distribute the values to the sub-units
% %                 self = distributeSubData(self,'mask',value);
% %             end
%             self.mask = value;
%        end
%         
%        % set x
%        function self = set.x(self,value)
% %             if ~isempty(self.subUnitList) %#ok<*MCSUP>
% %                 % distribute the values to the sub-units
% %                 self = distributeSubData(self,'mask',value);
% %             end
%             self.x = value;
%         end
    
        % check that new objects added to the list are of the same type as
        % the main object
        function self = set.subUnitList(self,objArray) %#ok<*MCSV,*MCHC,*MCHV2>
            test = arrayfun(@(o)isa(o,class(self)),objArray);
            if ~prod(test) % all the objects must have the correct type
                error('Merged objects must be of the same type as the object container.')
            end
            self.subUnitList = objArray;
        end
        
        % function that gathers the data from the sub-units and place them
        % in the correct field. Always concatenate over the last
        % significant dimension (dispersions)
        function value = gatherSubData(self,fieldName)
            cl = class(self);
            switch cl
                case 'Bloc'
                    n = 3;
                case 'Zone'
                    n = 2;
                case 'Dispersion'
                    n = 1;
            end
%             sze = size(self.subUnitList(1).(fieldName));
%             n = ndims(self.subUnitList(1).(fieldName));
%             if (n == 2) && (sze(2)==1)
%                 n = 1;
%             end                
            value = cat(n,self.subUnitList.(fieldName));
%             self.(fieldName) = value;
        end
        
        % function that spreads the data from the contained object to the
        % sub-units
        function self = distributeSubData(self,fieldName,value)
            % list the number of element needed in each sub-object
            lengthList = arrayfun(@(o)length(o.(fieldName)),self.subUnitList);
            endList = cumsum(lengthList);
            startList = [1 endList(1:end-1)+1];
            if ~isempty(endList)
                s = arrayfun(@(o,s,e)setfield(o,fieldName,value(s:e)),self.subUnitList,startList,endList,'UniformOutput',0); 
                self.subUnitList = [s{:}];
            end
        end
        
        % functions used to make sure that merged objects behave
        % consistently with their own object type. (see Matlab help on
        % 'Modify Property Values with Access Methods')
        function self = set.x(self,value)
            if ~isempty(self.subUnitList)&&numel(self.subUnitList)>0
                % distribute the values to the sub-units
                self = distributeSubData(self,'x',value);
            end
            self.x = value;
        end
        
        function x = get.x(self)
            if ~isempty(self.subUnitList)&&numel(self.subUnitList)>0   % empty objects are not considered empty, so another test is needed using the length.
                x = gatherSubData(self,'x');
            else
                x = self.x;
            end
        end
        

        
        function y = get.y(self)
            if ~isempty(self.subUnitList)&&numel(self.subUnitList)>0
                y = gatherSubData(self,'y');
            else
                y = self.y;
            end
        end
        

        
        function dy = get.dy(self)
            if ~isempty(self.subUnitList)&&numel(self.subUnitList)>0
                dy = gatherSubData(self,'dy');
            else
                dy = self.dy;
            end
        end
        

        
        function mask = get.mask(self)            
            if ~isempty(self.subUnitList)&&numel(self.subUnitList)>0
                mask = gatherSubData(self,'mask');
            else
                mask = self.mask;
            end
        end
%         
%         function param = get.parameter(self)
%             if ~isempty(self.subUnitList)
%                 param = merge([self.subUnitList.parameter]);
%             else
%                 param = self.parameter;
%             end
%         end
%         
%         function self = set.parameter(self,value)
%             if ~isempty(self.subUnitList)
%                 % TO DO
%                 warning('Assignement of parameters not yet implemented for merged objects. See DataUnit.m, function set.parameter.')
%                 self.subUnitList(1).parameter = value;
%             else
%                 self.parameter = value;
%             end
%         end
    end
     
end

