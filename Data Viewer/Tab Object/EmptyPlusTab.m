classdef EmptyPlusTab < EmptyTab
    %
    % Just a special version of empty tab that allow the user to add new
    % tab
    %
    % SEE ALSO DISPERSIONTAB, DISPLAYMANAGER, EMPTYTAB
    
    properties
    end
    
    methods
        % Constructor
        function this = EmptyPlusTab(DisplayManager, tab)
            % call the superclass constructor
            this = this@EmptyTab(DisplayManager, tab);
            % set the name of the subtab 
            this.Parent.Title = '+';
        end %EmptyPlusTab
    end
    
end

