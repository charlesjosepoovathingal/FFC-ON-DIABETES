classdef ProcessDataUnit < matlab.mixin.Heterogeneous% < handle
% this class defines the structure and general attibute of all the objects
% that are used to process the data units. It aims at facilitating
% operations on the processing functions, to streamline the creation of
% new models and to make it easier to make new models for begginers.
%
% L Broche, University of Aberdeen, 6/7/18

    properties (Abstract)
        functionName@char       % character string, name of the model, as appearing in the figure legend
        labelY@char             % string, labels the Y-axis data in graphs
        labelX@char             % string, labels the X-axis data in graphs
        legendTag@cell          % cell of strings, contain the legend associated with the data processed
    end
    
    properties
        globalProcess@logical = false;  % set to 0 if the algorithm is distributed to each acquisition independently, 1 if the algorithm is applied to the entire dataset provided as an input
    end
    
    methods
        function self = ProcessDataUnit(varargin)
            % parsing the inputs, using the typical format ('param1',
            % value1, 'param2', value2,...)
            for i = 1:2:length(varargin)
                if isprop(model,varargin{i})
                    model = setfield(model,varargin{i},varargin{i+1}); %#ok<SFLD>
                end
            end
            % make some simple checks
            if ~selfCheck(self)
                error('Inconsistent inputs, object not created.')
            end
        end
        
        % test function to verify the object integrity (TO DO)
        function out = selfCheck(self)
            out = 1;
        end
    
        function tf = checkProcessData(this, parentObj)
            % init
            tf = 1;
            % check if process
            if isempty(parentObj.processingMethod)
                return
            end
            
            % check if process was already applied: same process &
            % parameter (do it for parameter)
            if strcmp(class(this), class(parentObj.processingMethod)) &&...
                ~isempty(parentObj.children)
                tf = 0;
            end
        end
        
        % main process function
        function [childObj, parentObj] = processData(this, parentObj)  
            % check data size to confirm process
            if ~checkProcessData(this, parentObj)
                childObj = [parentObj.children]; return
            end
            
            % get data
            data = getProcessData(this, parentObj);
            
            % apply process
            [model, new_data] = arrayfun(@(d) applyProcess(this, d), data, 'Uniform', 0); % include the whole data, for merging or other purposes (LB 11/2/19)
            
            % format output
            new_data = formatData(this, new_data);
            this = formatModel(this, model);    
                        
            % add processObj
            parentObj.processingMethod = this;
            
            % gather data and create childObj
            childObj = makeProcessData(this, new_data, parentObj);    
            
            % link the child and parent processes
            %link(parentObj, childObj); already done in MakeProcessData()
            %[Manu]
            
            % add other data (xLabel, yLabel,...)
            childObj = addOtherProp(this, childObj);
        end %processData
        
        % format output data from process: cell array to array of structure
        % This function could also be used to modify this in order to
        % gather all fit data for instance [Manu]
        function this = formatModel(this, model)
            
        end %formatData
        
        % dispatch the merge operation to the corresponding function
        function [childObj, parentObj] = processDataGroup(this,parentObj)
            childObj = applyProcess(this, parentObj);
        end
        
        % compare two process to determine if they are the same. This
        % function only check the necessary fields:
        % *class of the processObj (AverageAbs, Monoexp, Constant,...)
        % *property parameters (if parameters are the same, the results
        % will be the same)
        function tf = isequal(this, processObj)
            % dummy check
            if ~isa(processObj, 'ProcessDataUnit')
                tf = 0; return
            end
            % compare the class of the input and their parameters
            if ~strcmp(class(this), class(processObj))
                tf = 0;
            else
                tf = 1;
            end
        end %isequal
        
        % add other properties (xLabel, yLabel, legendTag
        function childObj = addOtherProp(this, childObj)
            % add xLabel and yLabel
            if ~isempty(this.labelX)
                [childObj.xLabel] = deal(this.labelX);
            end
            
            if ~isempty(this.labelY)
                [childObj.yLabel] = deal(this.labelY);
            end
            % add legendTag
            % do not add empty legeng (listener!)
            if ~isempty(this.legendTag{1})
                [childObj.legendTag] = this.legendTag{:};
            end
        end %addOtherProp
        
        % THIS = CHANGEPROCESSPARAMETER(THIS) creates a small gui to
        % modify the process parameter. 
        % If you want to use this function, you need to create a
        % changeSettings method in the wanted derived classes.
        % changeSettings need to handle the GUI creation (fill the figure)
        % See DataFit class for example.
        function this = changeProcessParameter(this)
            % check if parameter are available
            if all(strcmp(methods(this), 'changeSettings') == 0)
                return % no parameter
            end
            % create the figure
            fig = figure('Name',[this.functionName,' settings'],...
                'NumberTitle','off','MenuBar','none','ToolBar','none',...
                'Units','normalized','Position',[0.3 0.45 0.4 0.2]);
            % call the custom method
            this = changeSettings(this, fig);
        end %changeProcessParameter
    end
    
    methods (Abstract)
        applyProcess(this, data, parentObj)
    end
end