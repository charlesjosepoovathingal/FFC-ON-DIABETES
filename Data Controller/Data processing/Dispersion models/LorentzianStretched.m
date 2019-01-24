classdef LorentzianStretched < DispersionModel 
    % Stretched Lorentzian model for liquids with Gaussian diffusion and
    % restricted motion (phenomenological model).
    %
    % Lionel Broche, University of Aberdeen, 08/02/2017 (modified 23/08/18)
    
    properties
        modelName     = 'Streched Lorentzian profile';        
        modelEquation = '3/2*(1.2e-23/rhh^3).^2*[tau./(1+(2*pi*f*tau).^n) + 4*tau./(1+(2*2*pi*f*tau).^n)]';    
        variableName  = {'f'};     
        parameterName = {'rhh',   'tau',  'n'};  
        minValue      = [0,       0,     0];  
        maxValue      = [Inf,     1    ,   Inf];  
        startPoint    = [3e-9,   1e-6,     1];  
        isFixed       = [0        0         0];
        visualisationFunction@cell = {};
    end
    
    methods
        function this = LorentzianStretched
            % call superclass constructor
            this = this@DDispersionModel;
        end
    end
    
    methods        
        % function that allows estimating the start point.
        function this = evaluateStartPoint(this, xdata, ydata)
            % make sure the data is sorted
            [xdata,ord] = sort(xdata);
            ydata = ydata(ord);
            % estimate tau from the half-peak value
            if length(ydata)>10
                yLowFreq = 10^median(log10(ydata(1:10)));
            else
                yLowFreq = ydata(1);
            end
            [~,indm] = min(abs(ydata-yLowFreq/2));
            tau = 1/xdata(indm);
            % then rhh is estimated from the low-frequency limit
            rhh = (1.2e-23)^(1/3)/(yLowFreq/(5*tau)*2/3)^(1/6);
            this.startPoint = [rhh,tau,1];
        end
    end
end