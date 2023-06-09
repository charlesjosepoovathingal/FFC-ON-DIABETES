function opts_button = buildDisplayOptions(box)
%
% Add different display options buttons in a box
%

% + Create two panels: display options & data options
hbox = uix.HBox( 'Parent', box,'Spacing',10);

% + display options panel
panel_display_opts = uix.Panel( 'Parent', hbox,...
                   'Title', 'Display options',...
                   'Padding',2);
grid_display_opts= uix.Grid( 'Parent', panel_display_opts); 
box_display_opts = uix.HBox( 'Parent', grid_display_opts );

% + add 6 checkbox: data, error, legend, fit, mask, residual
% + data, legend
opts_button_box1 = uix.VButtonBox( 'Parent', box_display_opts,...
                                   'Spacing', 5,...
                                   'HorizontalAlignment','left',...
                                   'ButtonSize', [100 20] );                                
opts_button.DataCheckButton = uicontrol( 'Parent', opts_button_box1,...
                                         'Style', 'checkbox',...
                                         'Value',1,...
                                         'String', 'Show data',...
                                         'Tag','DataCheckButton');
opts_button.LegendCheckButton = uicontrol( 'Parent', opts_button_box1,...
                                           'Style', 'checkbox',...
                                           'Value',1,...
                                           'String', 'Show legend',...
                                           'Tag','LegendCheckButton');
% + error, mask              
opts_button_box2 = uix.VButtonBox( 'Parent', box_display_opts,...
                                   'Spacing', 5,...
                                   'HorizontalAlignment','left',...
                                   'ButtonSize', [100 20] );  
opts_button.ErrorCheckButton = uicontrol( 'Parent', opts_button_box2,...
                                          'Style', 'checkbox',...
                                          'Value',0,...
                                          'String', 'Show error',...
                                          'Tag','ErrorCheckButton');
opts_button.MaskCheckButton = uicontrol( 'Parent', opts_button_box2,...
                                         'Style', 'checkbox',...
                                         'Tag','MaskCheckButton',...
                                         'String', 'Show mask data');
% + fit, residual
opts_button_box3 = uix.VButtonBox( 'Parent', box_display_opts,...
                                   'Spacing', 5,...
                                   'HorizontalAlignment','left',...
                                   'ButtonSize', [100 20] );  
opts_button.FitCheckButton = uicontrol( 'Parent', opts_button_box3,...
                                      'Style', 'checkbox',...
                                      'Value',1,...
                                      'Tag','FitCheckButton',...
                                      'String', 'Show fit');                                
opts_button.ResidualCheckButton = uicontrol( 'Parent', opts_button_box3,...
                                      'Style', 'checkbox',...
                                      'Tag','ResidualCheckButton',...
                                      'String', 'Show residual');

% + data options panel
panel_data_opts = uix.Panel( 'Parent', hbox,...
                   'Title', 'Data options',...
                   'Padding',2);
grid_data_opts= uix.Grid( 'Parent', panel_data_opts); 
box_data_opts = uix.HBox( 'Parent', grid_data_opts );

% + add 6 components: X/Y current point, X/Y axis scaling, mask pushbutton,
% reset mask pushbutton.
% + X/Y value
opts_button_box4 = uix.VButtonBox( 'Parent', box_data_opts,...
                                   'Spacing', 5,...
                                   'HorizontalAlignment','left',...
                                   'ButtonSize', [100 20] );                                

opts_button_XVal = uix.HBox( 'Parent',  opts_button_box4);
uicontrol( 'Parent', opts_button_XVal,...
            'Style','text',...
            'String','X:');
opts_button.XPosText = uicontrol( 'Parent', opts_button_XVal,...
                                'Style','text',...
                                'HorizontalAlignment','left',...
                                'String','',...
                                'Tag','XPosText');
% uicontrol( 'Parent', opts_button_XVal,...
%             'Style','text',...
%             'HorizontalAlignment','left',...
%             'String','',...
%             'Tag','XUnitText');
               
opts_button_YVal = uix.HBox( 'Parent',  opts_button_box4);
uicontrol( 'Parent', opts_button_YVal,...
            'Style','text',...
            'String','Y:');
opts_button.YPosText = uicontrol( 'Parent', opts_button_YVal,...
                                'Style','text',...
                                'HorizontalAlignment','left',...
                                'String','',...
                                'Tag','YPosText');
% uicontrol( 'Parent', opts_button_YVal,...
%             'Style','text',...
%             'HorizontalAlignment','left',...
%             'String','',...
%             'Tag','YUnitText');

opts_button_XVal.Widths = [30 -1];
opts_button_YVal.Widths = [30 -1];

% + X/Y axis 
opts_button_box5 = uix.VButtonBox( 'Parent', box_data_opts,...
                                   'Spacing', 5,...
                                   'HorizontalAlignment','left',...
                                   'ButtonSize', [100 20] ); 
                               
opts_button_XAxis = uix.HButtonBox( 'Parent',  opts_button_box5);
uix.Text( 'Parent', opts_button_XAxis,...
            'String','XAxis: ');
opts_button.XAxisPopup = uicontrol( 'Parent', opts_button_XAxis,...
                                    'Style','popup',...
                                    'String', {'Linear','Log'},...
                                    'Value',2,...
                                    'Tag','XAxisPopup');
        
opts_button_YAxis = uix.HButtonBox( 'Parent',  opts_button_box5);
uix.Text( 'Parent', opts_button_YAxis,...
            'String','YAxis: ');        
opts_button.YAxisPopup = uicontrol( 'Parent', opts_button_YAxis,...
                                    'Style','popup',...
                                    'String', {'Linear','Log'},...
                                    'Value',2,...
                                    'Tag','YAxisPopup');        

% + mask data/reset mask
opts_button_box6 = uix.VButtonBox( 'Parent', box_data_opts,...
                                   'Spacing', 5,...
                                   'HorizontalAlignment','left',...
                                   'ButtonSize', [100 20] ); 
opts_button.MaskDataPushButton = uicontrol( 'Parent', opts_button_box6,...
                                            'Style', 'pushbutton',...
                                            'String', 'Mask data',...
                                            'Tag','MaskDataPushButton');
opts_button.ResetMaskPushButton = uicontrol( 'Parent', opts_button_box6,...
                                            'Style', 'pushbutton',...
                                            'String', 'Reset data',...
                                            'Tag','ResetMaskPushButton'); 
        
box_data_opts.Widths = [-1.1 -1.5 -1.2];        
end

