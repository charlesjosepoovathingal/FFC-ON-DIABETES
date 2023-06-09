classdef LsqCurveFit < FitAlgorithm
    %
    % Available weighted methods:
    % - 'none'
    % - 'data': use the data error w = 1./(dy.^2)
    % - {'andrews','bisquare','cauchy','fair',...
    %    'huber','logistic','ols','talwar','welsch'}
    % last options gather iterative weight methods
    % and use the FEX function from J.-A. Adrian (JA)
    % see https://github.com/JAAdrian/MatlabRobustNonlinLsq/blob/master/robustlsqcurvefit.m
    %
    properties
        name = 'lsqcurvefit';
    end

    methods
        % Constructor
        function this = LsqCurveFit
            % call superclass constructor
            this = this@FitAlgorithm;
            
            % create default options
            this.options = getOptions(this, 'default');
        end
    end
    
    methods 
        % Apply fit using lsqcurvefit/lsqnonlin
        function [coeff, error, gof] = applyFit(this, fun, xdata, ydata, dydata, x0, lb, ub)
            % create option structure 
            opts = optimoptions(@lsqcurvefit,...
                            'Algorithm',this.options.Algorithm,...
                            'Display','off',...
                            'FunctionTolerance',this.options.FunctionTolerance,...
                            'MaxIterations',this.options.MaxIterations,...
                            'StepTolerance',this.options.StepTolerance);
            
            % If Levenberg-Marquadt remove boundaries
            if strcmp(opts.Algorithm,'levenberg-marquardt')
                lb = []; ub = [];
            end
                        
            % try/catch structure
            try
                % check the weight options
                switch this.options.Weight
                    case 'none'
                        % apply fit
                        [coeff,resnorm,residuals,~,~,~,jacobian] = lsqcurvefit(fun,...
                            x0, xdata, ydata, lb, ub, opts);
                    case 'data'
                        % apply fit with 1./(dydata.^2) weight
                        [coeff,resnorm,residuals,~,~,~,jacobian] = lsqnonlin(@wfun,...
                            x0, ub, lb, opts, xdata, ydata, 1./(dydata.^2));
                    otherwise
                        % apply robust fit:
                        % FEX function from J.-A. Adrian (JA)
                        % see https://github.com/JAAdrian/MatlabRobustNonlinLsq/blob/master/robustlsqcurvefit.m
                        [coeff,resnorm,residuals,~,~,~,jacobian] = robustlsqcurvefit(fun,...
                            x0, xdata, ydata,lb, ub, this.options.Weight, opts);
                end           
            catch ME
                coeff = x0;
                error = nan(size(x0));
                gof = struct('sse',[],'rsquare',[],'adjrsquare',[],'RMSE',[]);
                disp(ME)
                return
            end

            % get gof and error
            gof = this.getGOF(coeff, ydata, residuals, resnorm);
            try
                ci = nlparci(coeff,residuals,'jacobian',jacobian);
                error = coeff - ci(:,1)';
            catch
                error = nan(size(coeff));
            end
            %%% ----------------- Weight calculation ------------------ %%%
            function err = wfun(coeff, xdata, ydata, weight)
                % get error
                err = weight.*(fun(coeff, xdata) - ydata);
            end
        end % applyFit
    end
    
    methods (Static)       
        % Calculate the goodness of fit: rsquare, adjrsquare, RMSE, SSE
        function gof = getGOF(coeff, ydata, residual, resnorm)
            % calculate the sum of square total and error
            sst = sum((ydata-mean(ydata)).^2); %sum of square total
            sse = sum(residual.^2); %sum of square error
            nData = length(ydata); 
            nCoeff = length(coeff); 
            % build the output struct with rsquare, adjrsquare and RMSE
            gof.sse = sse;
            gof.rsquare =  1 - sse/sst; 
            gof.adjrsquare = 1 - ((nData-1)/(nData - nCoeff))*(sse/sst); 
            gof.RMSE = sqrt(resnorm);
        end %getGOF  
    end
    
    % Set/Get options
    methods               
        % Get solver options. Possible flag are:
        % 'default': get the default options
        % 'all': get all the possible options
        % 'format': get the format of the options (if uitable)
        % 'current': get the current options
        function options = getOptions(this, flag)
            % check input
            if strcmp(flag,'default')
                % create a structure with default option
                options = struct('Algorithm','levenberg-marquardt',...
                    'FunctionTolerance',1e-6,...
                    'MaxIterations',400,...
                    'StepTolerance',1e-6,...
                    'Weight','none');
            elseif strcmp(flag,'all')
                % create a structure with all possible string and default numeric option
                options = struct('Algorithm',{{'trust-region-reflective','levenberg-marquardt'}},...
                    'FunctionTolerance',1e-6,...
                    'MaxIterations',400,...
                    'StepTolerance',1e-6,...
                    'Weight',{{'none','data','andrews','bisquare','cauchy','fair',...
                                'huber','logistic','ols','talwar','welsch'}});   
            elseif strcmp(flag,'format')
                % create a structure with the format the options
                options = {{'trust-region-reflective','levenberg-marquardt'};...
                    'numeric';...
                    'numeric';...
                    'numeric';...
                    {'none','data','andrews','bisquare','cauchy','fair',...
                           'huber','logistic','ols','talwar','welsch'}};                 
            else
                % create a structure with the current options
                options = this.options;
            end
        end %getOptions
        
        % Set options
        function this = setOptions(this, fld, val)  
            % check input
            if ~any(strcmp(fieldnames(this.options), fld))
                warning('LsqCurveFit: option name is not recognized')
                return
            else
                % switch according to the field
                switch fld
                    case 'Algorithm'
                        if ~any(strcmp({'trust-region-reflective',...
                                'levenberg-marquardt'},val))
                            warning('LsqCurveFit: wrong algorithm')
                            return
                        else
                            this.options.Algorithm = val;
                        end
                    case 'FunctionTolerance'
                        if ~isnumeric(val) || val < 0
                            warndlg('LsqCurveFit: wrong function tolerance')
                            return
                        else
                            this.options.FunctionTolerance = val;
                        end
                    case 'MaxIterations'
                        if ~isnumeric(val) || val < 0
                            warndlg('LsqCurveFit: wrong max iterations')
                            return
                        else
                            this.options.MaxIterations = val;
                        end
                    case 'StepTolerance'
                        if ~isnumeric(val) || val < 0
                            warndlg('LsqCurveFit: wrong step tolerance')
                            return
                        else
                            this.options.StepTolerance = val;
                        end
                    case 'Weight'
                        if ~any(strcmp({'none','data','andrews','bisquare','cauchy','fair',...
                                'huber','logistic','ols','talwar','welsch'}, val))
                            warning('LsqCurveFit: wrong weight method')
                            return
                        else
                            this.options.Weight = val;
                        end
                end
            end
        end %setOptions
    end
end