classdef FitModel
    
    properties
        
        modelName = '';        % character string, name of the model, as appearing in the figure legend
        modelEquation = '';    % character string, equation that relates the Larmor frequency (Hz) to the parameters to R1 (s^{-1})
        modelHandle;           % function handle that refers to the equation, or to any other function defined by the user
        variableName = '';     % List of characters, name of the variables appearing in the equation
        parameterName = {};    % List of characters, name of the parameters appearing in the equation
        isFixed = [];          % array of booleans, set to 1 if the corresponding parameter is fixed, 0 if they are to be optimised by the fit. 
        minValue = [];         % array of values, minimum values reachable for each parameter, respective to the order of parameterName
        maxValue = [];         % array of values, maximum values reachable for each parameter, respective to the order of parameterName
        startPoint = [];       % array of values, starting point for each parameter, respective to the order of parameterName 
        bestValue = [];        % array of values, estimated value found from the fit.
        errorBar = [];         % 2 x n array of values, provide the 95% confidence interval on the estimated fit values (lower and upper errors)
        fitobj = [];           % fitting object created after the model is used for fitting.
    end
    
    methods
        function self = FitModel(varargin)
            for i = 1:2:length(varargin)
                if isprop(model,varargin{i})
                    self.(varargin{i}) = varargin{i+1};
                end
            end
        end
        
        function self = makeFunctionHandle(self)
            self.modelHandle = str2func(self.modelEquation);
        end
        
        % provides the estimations of the model at points x, using the
        % current parameters
        function y = evalModel(self,x)
            
        end
    end
end