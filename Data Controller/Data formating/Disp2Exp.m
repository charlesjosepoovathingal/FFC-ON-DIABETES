classdef Disp2Exp < ProcessDataUnit
    
    % this class performs the fit over the dispersion data. Several
    % contributions can be added together by using an array of object, each
    % one containing a different component.
    % Performing the fit is done using the function applyProcessFunction,
    % then the result can be used to generate an Experiment object if
    % required (using makeExp).
    
    properties
        model;       % Dispersion model that sums up all the contributions. Used for the processing.
        subModel;    % List of sub-models to be added up.
    end
    
    properties (Abstract)
        
    end
    
    methods
        
        function self = Disp2Exp(varargin)
            self@ProcessDataUnit;
            % TODO: better parsing. Assuming it is the list of sub-models
            self.model = DefaultDispersionModel;
            if ~isempty(varargin)
                self = addModel(self,varargin{1});
            end
        end
        
        
        
        % function that allows estimating the start point. It should be 
        % over-riden by the derived classes
        function self = evaluateStartPoint(self,x,y)
            % you may add some estimation technique here or let each
            % component estimate its parameters using their own methods 
            for indProc = 1:length(self)
                for i = 1:length(self(indProc).subModel)
                    self(indProc).subModel(i) = evaluateStartPoint(self(indProc).subModel(i),x,y);
                end
            end
        end
                
        
        % redefine the access functions so that any change to the model or
        % submodel list updates the entire object
        function self = set.model(self,value)
            self.model = value;
            self = updateSubModel(self);
        end
        
%         function self = set.subModel(self,value)
%             self.subModel = value;
%             self = wrapSubModelList(self); % update the function handles
%         end
        
        % sets a function handle into the log space
        % fhlog = log10(fh)
        function fhlog = makeLogFunction(self)
            par = functions(self.model.modelHandle);
            ind = strfind(par.function,')');
            inputList = par.function(3:ind(1)-1);
            fhandle = self.model.modelHandle; %#ok<NASGU>
            fhlog = eval(['@(' inputList ') log10(fhandle(' inputList '))']); % str2func won't work here...
%             fhlog = str2func(['@(' inputList ') log10(fh(' inputList '))']);
        end
        
%         
%         % function that applies a list of processing objects for one
%         % dispersion object 'disp'
%         function self = applyProcessFunctionToSingleDisp(self,dispersion)
%             % keep track of the index of each model, for convenience
%             selfindex = num2cell(1:length(self),1);
%             % update the main model
%             self = wrapSubModelList(self);
% %             self.subModel = arrayfun(@(mod)evaluateStartPoint(mod,disp.x,disp.y),self.subModel);
%             self = gatherBoundaries(self);
%             % check that the model is not empty
%             if isempty(self.subModel)
%                 disp('Model is empty. Please select a dispersion model.')
%                 return
%             end
%             % perform the calculations
%             selfCell = arrayfun(@(d2e,i) process(d2e,dispersion,i),self,selfindex,'UniformOutput',0);
%             self = [selfCell{:,:}];
%             % store the results in the dispersion object
%             dispersion.processingMethod = self;
%         end
%         
%         % function that applies a list of processing objects to a list of
%         % dispersion objects. The result is a table of processing objects.
%         function [self,exp] = applyProcessFunction(self,disp)
%             selfCell = arrayfun(@(d) applyProcessFunctionToSingleDisp(self,d),disp,'UniformOutput',0);
%             self = [selfCell{:,:}];
%             exp = DataUnit;
%             [disp,exp] = link(disp,exp);
%         end
%         
        % evaluate the function over the range of values provided by the
        % array x
        function y = evaluate(self,x)
            y = evaluate(self.model,x);
        end
        
        % evaluate n points from x1 to x2, for easy and nice plotting
        function y = evaluateRange(self,x1,x2,n)
            y = evaluateRange(self.model,x1,x2,n);
        end
        
        % make a list of all the sub-models
        function list = makeModelList(self)
            if length(self)>1
                list = arrayfun(@(o)makeModelList(o),self,'UniformOutput',0);
            else
                list = arrayfun(@(i)class(self.subModel(i)),1:length(self.subModel),'UniformOutput',0);
            end
        end
        
        % TO DO
        % generate a new object from a list of already processed dispersion
        % objects. Makes an experiment from all the dispersion objects that
        % have been processed with an object of the same class as 'self'
        % (which may be an array).
        % the user may also provide a list of parameters to pre-fill the
        % experiment object ('x',x_array,'xlabel','some string',...)
        % TO DO: provide the type of experiment object so that one can
        % customise the behaviour of the output depending on the experiment
        % TO DO: cluster the data by label, put cluster name as legend
        function [exp,disp] = makeExp(self,disp,varargin)
            % treat the case when the processing object is a list
            if length(self)>1
                [exp,disp] = arrayfun(@(o)makeExp(o,disp),self,'UniformOutput',0);
                exp = [exp{:}];
                disp = [disp{:}];
                return
            end
            % now we only have one processing object, and a list of data
            % units
            
            % make one experiment object per parameter in the fit object
            % (do not consider the fixed parameters)
            [~,parameterName] = gatherParameterNames(self);
            exp(1:length(parameterName)) = Experiment(varargin{:});
            for indExp = 1:length(parameterName)
                if isempty(exp(indExp).legendTag)
                    exp(indExp).legendTag = self.functionName;
                end
                if isempty(exp(indExp).yLabel)
                    exp(indExp).yLabel = parameterName{indExp};
                end
            end
            
            % finds all the datasets using the same fitting algorithm
            modelClass = makeModelList(self);
            matchIndex = arrayfun(@(o)cellfun(@(c)isequal(c,modelClass),makeModelList(o.processingMethod),'UniformOutput' ,0),disp,'UniformOutput',0);
            % now collect the data and store it in the experiment object
            for indDisp = 1:length(matchIndex)
                for indMod = 1:length(disp(indDisp).processingMethod)
                    if matchIndex{indDisp}{indMod}
                        for indExp = 1:length(parameterName)
                            exp(indExp).y(end+1) = disp(indDisp).processingMethod(indMod).model.bestValue(indExp);
                            exp(indExp).dy(end+1) = disp(indDisp).processingMethod(indMod).model.errorBar(indExp);
                        end
                        % link the children and parent objects
                        [exp(indExp),disp(indDisp)] = link(exp(indExp),disp(indDisp));
                    end
                end
            end
            
        end
    end
    
    methods (Static)
    
        % set the fixed parameters for a given 
        function fhfixed = setFixedParameter(fh,isFixed,startPoint)
            paramlist = '';
            n = 0;
            for i = 1:length(isFixed)
                if ~isFixed(i)
                    n = n+1;
                    paramlist = [paramlist 'c(' num2str(n) ')'];
                else
                    paramlist = [paramlist num2str(startPoint(i))];
                end
                if i ~=length(isFixed)
                    paramlist = [paramlist ','];
                end
            end
            fhfixed = eval(['@(c,x) fh([' paramlist '],x)']);
        end
        
    end
    
    
    methods (Sealed)
        
        % standard naming convention for the processing function (one
        % dispersion, several processing objects)
        function [exp,dispersion] = processData(self,dispersion)
            % keep track of the index of each model, for convenience
            selfindex = num2cell(1:length(self),1);
%             % update the main model list if necessary
%             self = wrapSubModelList(self);
            % check that the model is not empty
            empt = arrayfun(@(o)isempty(o.subModel),self);
            if sum(empt)
                disp('Model is empty. Please select a dispersion model.')
                return
            end
            % perform the calculations
            selfCell = arrayfun(@(d2e,i) process(d2e,dispersion,i),self,selfindex,'UniformOutput',0);
            self = [selfCell{:,:}];
            % store the results in the dispersion object
            dispersion.processingMethod = self;
            exp = [];
        end
        
    end
    
end