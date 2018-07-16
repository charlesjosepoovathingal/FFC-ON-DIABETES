classdef Dispersion < DataUnit
    %
    % DISPERSION is a container for "dispersion" data from Stelar SPINMASTER
    %
    % SEE ALSO BLOC, ZONE, DATAUNIT, DISPERSIONMODEL
    
    properties
        model = [] % cell array of DispersionModel object
        filter = [] % cell array of Filter object
        % See DataUnit for other properties
    end
    
    methods (Access = public)  
        % Constructor
        % Dispersion can build structure or array of structure. Input format is
        % equivalent to DataUnit: 
        % cell(s) input: array of structure
        % other: structure
        function obj = Dispersion(model, filter, varargin)
            % call DataUnit constructor
            obj = obj@DataUnit(varargin{:}); 
            % fill model field
            if ~isempty(model)
                if size(obj) == 1
                    obj.model = model;
                else
                    [obj.model] = model{:};
                end
            end
            % fill filter field
            if ~isempty(filter)
                if size(obj) == 1
                    obj.filter = filter;
                else
                    [obj.filter] = filter{:};
                end
            end                              
        end %Dispersion
    end
    
    methods (Access = public)        
        % Merge several Dispersion object. If Dispersion objects are
        % already merged (parent = 1xN Dispersion) then unmerged them.
        function obj = merge(obj) 
            
        end %merge
        
        % Average several Dispersion object data (X, Y) and create a new
        % Dispersion object
        function obj = average(obj)
            
        end %average
        
        % Export data from Dispersion object in text file.
        function export(obj,method)
            
        end %export
    end
    
end