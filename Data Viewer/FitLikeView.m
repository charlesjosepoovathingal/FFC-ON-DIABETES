classdef FitLikeView < handle
    %
    % View for the FitLike menu
    %
    
    properties
        gui % GUI (Menu FitLike)
        FitLike % Presenter
    end
    
    methods
        % Constructor
        function this = FitLikeView(FitLike)
            %%--------------------------BUILDER--------------------------%%
            % Store a reference to the presenter
            this.FitLike = FitLike;                     
            % Make the figure
            gui = buildFitLikeView();
            this.gui = guihandles(gui);           
            %%-------------------------CALLBACK--------------------------%%
            %% File Menu
            % Open function
            set(this.gui.Open, 'callback', ...
                @(src, event) this.FitLike.open());
            % open folder
            set(this.gui.OpenFolder, 'callback', ...
                @(src, event) this.FitLike.opendir());
            % Remove funcion
            set(this.gui.Remove, 'callback', ...
                @(src, event) this.FitLike.remove());
            % Export function
            set(this.gui.Export_Dispersion, 'callback', ...
                @(src, event) this.FitLike.export(src))
            % Save function
            set(this.gui.Save, 'callback',...
                @(src, event) this.FitLike.save());
            % Close function
            set(this.gui.menu,  'closerequestfcn', ...
                @(src,event) this.FitLike.closeWindowPressed());          
            set(this.gui.Quit, 'callback', ...
                @(src, event) this.FitLike.closeWindowPressed()); 
            %% Edit Menu
            % Add label function
            set(this.gui.Label, 'callback', ...
                @(src, event) this.FitLike.addLabel(src)); 
            % Move function
            
            % Copy function
            
            % Sort function
            
            % Merge function
%             set(this.gui.Merge, 'callback', ...
%                 @(src, event) this.FitLike.merge());
            % Mask function
            
            %% View Menu
            % Axis function
            
            % Plot function
            
            % CreateFig function
            set(this.gui.Create_Fig, 'callback', ...
                @(src, event) this.FitLike.createFig());
            %% Tool Menu
            % Filter function
            
            % Mean function
            
            % Normalise
            
            % BoxPlot
            
            %% Display Menu
            % Hide/Show function: FileManager
            set(this.gui.FileManager, 'callback',...
                @(src,event) this.FitLike.showWindow(src));  
            % Hide/Show function: DisplayManager         
            set(this.gui.DisplayManager, 'callback',...
                @(src,event) this.FitLike.showWindow(src));           
            % Hide/Show function: ProcessingManager
            set(this.gui.ProcessingManager, 'callback',...
                @(src,event) this.FitLike.showWindow(src));  
            % Hide/Show function: ModelManager
            set(this.gui.ModelManager, 'callback',...
                @(src,event) this.FitLike.showWindow(src));            
            % Hide/Show function: AcquisitionManager
            
            %% Help Menu
            % Documentation function

        end
        
        % Destructor
        function deleteWindow(this)
            %remove the closerequestfcn from the figure, this prevents an
            %infitie loop with the following delete command
            set(this.gui.menu,  'closerequestfcn', '');
            %delete the figure
            delete(this.gui.menu);
            %clear out the pointer to the figure - prevents memory leaks
            this.gui = [];
        end
        
        % Add label items to the label list
        function [this, icon] = addLabelItem(this, new_label)
            % check the length of the list
            n = numel(this.gui.LabelList.Children);
            
            if n > 6; icon = []; return; end
            % get the icon
            icon = [pwd,'\Data Viewer\icons\',num2str(n),'.png'];
            % add the icon
            uimenu( this.gui.LabelList,...
                'Label', new_label,'UserData',icon,...
                'Callback',@(src,event) this.FitLike.addLabel(src));
            drawnow;
            
            % add java icon - close and open menu to prevent errors
            % See http://undocumentedmatlab.com/blog/customizing-menu-items-part-2/#dynamic           
            jMenuLabel = findjobj(this.gui.LabelList);
            
            jMenuLabel.doClick(); % open the File menu
            jMenuLabel.doClick(); % close the menu           
            pause(0.001); %EDT
            
            jLabel = jMenuLabel.getMenuComponent(n);
            jLabel.setIcon(javax.swing.ImageIcon(icon));
        end %addLabelItem
    end
    
end

