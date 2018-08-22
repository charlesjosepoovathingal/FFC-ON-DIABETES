function handles = ico_redim_build(hParent)
% ICO_REDIM_BUILD
%-------------------------------------------------------------------------------
% File name   : ico_redim_build.m
% Generated on: 21-Mar-2007 09:47:43
% Description :
%-------------------------------------------------------------------------------

% --- PANELS -------------------------------------
handles.uipanel1 = uipanel(	'Parent', hParent, ...
  'Tag', 'uipanel1', ...
  'Units', 'pixels', ...
  'Position', [10 10 175 335], ...
  'FontWeight', 'bold', ...
  'BackgroundColor', [0.937 0.937 0.937], ...
  'Title', '');

handles.uipanel2 = uipanel(	'Parent', hParent, ...
  'Tag', 'uipanel2', ...
  'Units', 'pixels', ...
  'Position', [190 180 360 165], ...
  'FontWeight', 'bold', ...
  'BackgroundColor', [0.937 0.937 0.937], ...
  'Title', '');

handles.uipanel3 = uipanel(	'Parent', hParent, ...
  'Tag', 'uipanel3', ...
  'Units', 'pixels', ...
  'Position', [190 10 360 165], ...
  'FontWeight', 'bold', ...
  'BackgroundColor', [0.937 0.937 0.937], ...
  'Title', '');

handles.uipanel4 = uipanel(	'Parent', hParent, ...
  'Tag', 'uipanel4', ...
  'Units', 'pixels', ...
  'Position', [10 349 540 62], ...
  'BackgroundColor', [0.937 0.937 0.937], ...
  'Title', '');

% --- STATIC TEXTS -------------------------------------
handles.text11 = uicontrol(	'Parent', handles.uipanel1, ...
  'Tag', 'text11', ...
  'Style', 'text', ...
  'Units', 'pixels', ...
  'Position', [0 318 173 15], ...
  'FontWeight', 'bold', ...
  'ForegroundColor', [1 1 1], ...
  'BackgroundColor', [0 0.251 0.502], ...
  'String', '  Available Icons', ...
  'HorizontalAlignment', 'left');

handles.text8 = uicontrol(	'Parent', handles.uipanel2, ...
  'Tag', 'text8', ...
  'Style', 'text', ...
  'Units', 'pixels', ...
  'Position', [10 122 50 15], ...
  'BackgroundColor', [0.937 0.937 0.937], ...
  'String', 'Width');

handles.text9 = uicontrol(	'Parent', handles.uipanel2, ...
  'Tag', 'text9', ...
  'Style', 'text', ...
  'Units', 'pixels', ...
  'Position', [70 122 50 15], ...
  'BackgroundColor', [0.937 0.937 0.937], ...
  'String', 'Height');

handles.text12 = uicontrol(	'Parent', handles.uipanel2, ...
  'Tag', 'text12', ...
  'Style', 'text', ...
  'Units', 'pixels', ...
  'Position', [0 148 358 15], ...
  'FontWeight', 'bold', ...
  'ForegroundColor', [1 1 1], ...
  'BackgroundColor', [0 0.251 0.502], ...
  'String', '  Original Icon', ...
  'HorizontalAlignment', 'left');

handles.text3 = uicontrol(	'Parent', handles.uipanel3, ...
  'Tag', 'text3', ...
  'Style', 'text', ...
  'Units', 'pixels', ...
  'Position', [10 122 40 15], ...
  'BackgroundColor', [0.937 0.937 0.937], ...
  'String', 'Width');

handles.text4 = uicontrol(	'Parent', handles.uipanel3, ...
  'Tag', 'text4', ...
  'Style', 'text', ...
  'Units', 'pixels', ...
  'Position', [56 122 40 15], ...
  'BackgroundColor', [0.937 0.937 0.937], ...
  'String', 'Height');

handles.text5 = uicontrol(	'Parent', handles.uipanel3, ...
  'Tag', 'text5', ...
  'Style', 'text', ...
  'Units', 'pixels', ...
  'Position', [102 122 40 15], ...
  'BackgroundColor', [0.937 0.937 0.937], ...
  'String', 'Margin');

handles.text6 = uicontrol(	'Parent', handles.uipanel3, ...
  'Tag', 'text6', ...
  'Style', 'text', ...
  'Units', 'pixels', ...
  'Position', [148 122 70 15], ...
  'BackgroundColor', [0.937 0.937 0.937], ...
  'String', 'Location');

handles.text7 = uicontrol(	'Parent', handles.uipanel3, ...
  'Tag', 'text7', ...
  'Style', 'text', ...
  'Units', 'pixels', ...
  'Position', [225 122 60 15], ...
  'BackgroundColor', [0.937 0.937 0.937], ...
  'String', 'String');

handles.text14 = uicontrol(	'Parent', handles.uipanel3, ...
  'Tag', 'text14', ...
  'Style', 'text', ...
  'Units', 'pixels', ...
  'Position', [0 149 358 15], ...
  'FontWeight', 'bold', ...
  'ForegroundColor', [1 1 1], ...
  'BackgroundColor', [0 0.251 0.502], ...
  'String', '  New Icon', ...
  'HorizontalAlignment', 'left');

handles.text10 = uicontrol(	'Parent', handles.uipanel4, ...
  'Tag', 'text10', ...
  'Style', 'text', ...
  'Units', 'pixels', ...
  'Position', [0 45 538 15], ...
  'FontWeight', 'bold', ...
  'ForegroundColor', [1 1 1], ...
  'BackgroundColor', [0 0.251 0.502], ...
  'String', '  Icon File', ...
  'HorizontalAlignment', 'left');

% --- PUSHBUTTONS -------------------------------------
handles.PbBeforeRefresh = uicontrol(	'Parent', handles.uipanel2, ...
  'Tag', 'PbBeforeRefresh', ...
  'Style', 'pushbutton', ...
  'Units', 'pixels', ...
  'Position', [130 99 62 23], ...
  'String', 'Refresh', ...
  'Callback', @PbBeforeRefresh_Callback);

handles.PbPrevBefore = uicontrol(	'Parent', handles.uipanel2, ...
  'Tag', 'PbPrevBefore', ...
  'Style', 'pushbutton', ...
  'Units', 'pixels', ...
  'Position', [10 10 35 35], ...
  'String', '');

handles.PbAfterView = uicontrol(	'Parent', handles.uipanel3, ...
  'Tag', 'PbAfterView', ...
  'Style', 'pushbutton', ...
  'Units', 'pixels', ...
  'Position', [300 99 50 23], ...
  'String', 'View', ...
  'Callback', @PbAfterView_Callback);

handles.PbPrevAfter = uicontrol(	'Parent', handles.uipanel3, ...
  'Tag', 'PbPrevAfter', ...
  'Style', 'pushbutton', ...
  'Units', 'pixels', ...
  'Position', [10 10 35 35], ...
  'String', '', ...
  'Callback', @PbPrevAfter_Callback);

handles.PbLoadIcoFile = uicontrol(	'Parent', handles.uipanel4, ...
  'Tag', 'PbLoadIcoFile', ...
  'Style', 'pushbutton', ...
  'Units', 'pixels', ...
  'Position', [419 9 25 25], ...
  'String', '...', ...
  'Callback', @PbLoadIcoFile_Callback);

handles.PbPreview = uicontrol(	'Parent', handles.uipanel4, ...
  'Tag', 'PbPreview', ...
  'Style', 'pushbutton', ...
  'Units', 'pixels', ...
  'Position', [451 9 80 25], ...
  'String', '        Preview', ...
  'CData', reshape([NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.996078431372549;0.764705882352941;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.996078431372549;1;0.909803921568627;0.486274509803922;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.996078431372549;1;0.913725490196078;0.63921568627451;0.588235294117647;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.996078431372549;1;0.901960784313726;0.635294117647059;0.576470588235294;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;1;1;0.901960784313726;0.627450980392157;0.572549019607843;NaN;NaN;NaN;NaN;NaN;NaN;0.549019607843137;0.568627450980392;0.568627450980392;NaN;NaN;0.929411764705882;0.850980392156863;0.635294117647059;0.572549019607843;NaN;NaN;NaN;NaN;NaN;0.52156862745098;0.662745098039216;0.717647058823529;0.682352941176471;0.674509803921569;0.568627450980392;0.584313725490196;0.572549019607843;0.462745098039216;0.592156862745098;NaN;NaN;NaN;NaN;NaN;0.498039215686275;0.866666666666667;0.898039215686275;0.568627450980392;0.505882352941176;0.568627450980392;0.658823529411765;0.745098039215686;0.549019607843137;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.619607843137255;0.949019607843137;0.72156862745098;0.580392156862745;0.682352941176471;0.792156862745098;0.815686274509804;0.847058823529412;0.76078431372549;0.498039215686275;NaN;NaN;NaN;NaN;NaN;0.541176470588235;0.717647058823529;0.63921568627451;0.580392156862745;0.725490196078431;0.847058823529412;0.866666666666667;0.858823529411765;0.854901960784314;0.890196078431373;0.580392156862745;NaN;NaN;NaN;NaN;NaN;0.549019607843137;0.698039215686274;0.549019607843137;0.647058823529412;0.847058823529412;0.874509803921569;0.894117647058824;0.890196078431373;0.858823529411765;0.898039215686275;0.588235294117647;NaN;NaN;NaN;NaN;NaN;0.533333333333333;0.674509803921569;0.623529411764706;0.741176470588235;0.866666666666667;0.890196078431373;0.968627450980392;0.972549019607843;0.901960784313726;0.854901960784314;0.556862745098039;NaN;NaN;NaN;NaN;NaN;NaN;0.525490196078431;0.72156862745098;0.788235294117647;0.862745098039216;0.894117647058824;0.968627450980392;0.992156862745098;0.984313725490196;0.701960784313725;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.525490196078431;0.623529411764706;0.83921568627451;0.87843137254902;0.87843137254902;0.913725490196078;0.992156862745098;0.862745098039216;0.52156862745098;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.525490196078431;0.537254901960784;0.729411764705882;0.823529411764706;0.796078431372549;0.611764705882353;0.498039215686275;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.525490196078431;0.556862745098039;0.549019607843137;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.705882352941177;0.611764705882353;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.717647058823529;0.709803921568627;0.537254901960784;0.4;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.717647058823529;0.701960784313725;0.537254901960784;0.47843137254902;0.584313725490196;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.72156862745098;0.698039215686274;0.529411764705882;0.47843137254902;0.588235294117647;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.741176470588235;0.694117647058824;0.537254901960784;0.47843137254902;0.584313725490196;NaN;NaN;NaN;NaN;NaN;NaN;0.592156862745098;0.631372549019608;0.627450980392157;NaN;NaN;0.83921568627451;0.529411764705882;0.482352941176471;0.592156862745098;NaN;NaN;NaN;NaN;NaN;0.552941176470588;0.764705882352941;0.905882352941176;0.901960784313726;0.890196078431373;0.627450980392157;0.654901960784314;0.615686274509804;0.415686274509804;0.580392156862745;NaN;NaN;NaN;NaN;NaN;0.509803921568627;0.870588235294118;0.996078431372549;0.780392156862745;0.709803921568627;0.768627450980392;0.862745098039216;0.933333333333333;0.607843137254902;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.666666666666667;0.996078431372549;0.862745098039216;0.788235294117647;0.862745098039216;0.949019607843137;0.968627450980392;1;0.854901960784314;0.52156862745098;NaN;NaN;NaN;NaN;NaN;0.588235294117647;0.87843137254902;0.847058823529412;0.788235294117647;0.898039215686275;0.992156862745098;1;1;1;1;0.623529411764706;NaN;NaN;NaN;NaN;NaN;0.596078431372549;0.874509803921569;0.768627450980392;0.831372549019608;0.988235294117647;1;1;1;1;1;0.623529411764706;NaN;NaN;NaN;NaN;NaN;0.568627450980392;0.807843137254902;0.831372549019608;0.909803921568627;1;1;1;1;1;0.980392156862745;0.596078431372549;NaN;NaN;NaN;NaN;NaN;NaN;0.564705882352941;0.917647058823529;0.956862745098039;1;1;1;1;1;0.764705882352941;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.564705882352941;0.705882352941177;0.984313725490196;1;1;1;1;0.866666666666667;0.552941176470588;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.564705882352941;0.564705882352941;0.823529411764706;0.925490196078431;0.898039215686275;0.662745098039216;0.513725490196078;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.556862745098039;0.588235294117647;0.580392156862745;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.294117647058824;0.419607843137255;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.317647058823529;0.317647058823529;0.117647058823529;0.290196078431373;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.317647058823529;0.317647058823529;0.125490196078431;0.294117647058824;0.745098039215686;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.32156862745098;0.305882352941176;0.113725490196078;0.294117647058824;0.784313725490196;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.333333333333333;0.294117647058824;0.12156862745098;0.305882352941176;0.776470588235294;NaN;NaN;NaN;NaN;NaN;NaN;0.737254901960784;0.76078431372549;0.756862745098039;NaN;NaN;0.709803921568627;0.152941176470588;0.305882352941176;0.792156862745098;NaN;NaN;NaN;NaN;NaN;0.709803921568627;0.850980392156863;0.984313725490196;1;0.996078431372549;0.756862745098039;0.807843137254902;0.749019607843137;0.372549019607843;0.725490196078431;NaN;NaN;NaN;NaN;NaN;0.67843137254902;0.909803921568627;1;0.956862745098039;0.933333333333333;0.945098039215686;0.984313725490196;0.992156862745098;0.733333333333333;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.788235294117647;1;0.968627450980392;0.949019607843137;0.968627450980392;0.988235294117647;0.996078431372549;1;0.905882352941176;0.690196078431373;NaN;NaN;NaN;NaN;NaN;0.729411764705882;0.937254901960784;0.976470588235294;0.949019607843137;0.972549019607843;0.996078431372549;1;1;1;1;0.752941176470588;NaN;NaN;NaN;NaN;NaN;0.733333333333333;0.937254901960784;0.956862745098039;0.96078431372549;0.996078431372549;1;1;1;1;1;0.752941176470588;NaN;NaN;NaN;NaN;NaN;0.717647058823529;0.905882352941176;0.976470588235294;0.980392156862745;1;1;1;1;1;0.992156862745098;0.737254901960784;NaN;NaN;NaN;NaN;NaN;NaN;0.72156862745098;0.992156862745098;0.992156862745098;1;1;1;1;1;0.847058823529412;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.72156862745098;0.815686274509804;0.992156862745098;1;1;1;1;0.917647058823529;0.709803921568627;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.72156862745098;0.713725490196078;0.886274509803922;0.952941176470588;0.933333333333333;0.776470588235294;0.682352941176471;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;0.713725490196078;0.733333333333333;0.725490196078431;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN],16.00000,80.00000,3.00000), ...
  'Callback', @PbPreview_Callback);

% --- EDIT TEXTS -------------------------------------
handles.EdBeforeW = uicontrol(	'Parent', handles.uipanel2, ...
  'Tag', 'EdBeforeW', ...
  'Style', 'edit', ...
  'Units', 'pixels', ...
  'Position', [10 100 50 21], ...
  'BackgroundColor', [1 1 1], ...
  'String', '35');

handles.EdBeforeH = uicontrol(	'Parent', handles.uipanel2, ...
  'Tag', 'EdBeforeH', ...
  'Style', 'edit', ...
  'Units', 'pixels', ...
  'Position', [70 100 50 21], ...
  'BackgroundColor', [1 1 1], ...
  'String', '35');

handles.EdAfterW = uicontrol(	'Parent', handles.uipanel3, ...
  'Tag', 'EdAfterW', ...
  'Style', 'edit', ...
  'Units', 'pixels', ...
  'Position', [10 100 40 21], ...
  'BackgroundColor', [1 1 1], ...
  'String', '35');

handles.EdAfterH = uicontrol(	'Parent', handles.uipanel3, ...
  'Tag', 'EdAfterH', ...
  'Style', 'edit', ...
  'Units', 'pixels', ...
  'Position', [56 100 40 21], ...
  'BackgroundColor', [1 1 1], ...
  'String', '35');

handles.EdMargin = uicontrol(	'Parent', handles.uipanel3, ...
  'Tag', 'EdMargin', ...
  'Style', 'edit', ...
  'Units', 'pixels', ...
  'Position', [102 100 40 21], ...
  'BackgroundColor', [1 1 1], ...
  'String', '10');

handles.EdString = uicontrol(	'Parent', handles.uipanel3, ...
  'Tag', 'EdString', ...
  'Style', 'edit', ...
  'Units', 'pixels', ...
  'Position', [224 100 70 21], ...
  'BackgroundColor', [1 1 1], ...
  'String', '');

handles.EdIcoFile = uicontrol(	'Parent', handles.uipanel4, ...
  'Tag', 'EdIcoFile', ...
  'Style', 'edit', ...
  'Units', 'pixels', ...
  'Position', [13 10 400 21], ...
  'BackgroundColor', [1 1 1], ...
  'String', '', ...
  'HorizontalAlignment', 'left');

% --- LISTBOXES -------------------------------------
handles.LbIcons = uicontrol(	'Parent', handles.uipanel1, ...
  'Tag', 'LbIcons', ...
  'Style', 'listbox', ...
  'Units', 'pixels', ...
  'Position', [10 10 155 285], ...
  'BackgroundColor', [1 1 1], ...
  'String', {'Listbox'}, ...
  'Callback', @LbIcons_Callback);

% --- POPUP MENU -------------------------------------
handles.PuLocation = uicontrol(	'Parent', handles.uipanel3, ...
  'Tag', 'PuLocation', ...
  'Style', 'popupmenu', ...
  'Units', 'pixels', ...
  'Position', [148 100 70 21], ...
  'BackgroundColor', [1 1 1], ...
  'String', {'Left','Right','Top','Bottom'});

% Default icons file
def_file = fullfile(pwd,'icons','icons.mat');

set(handles.EdIcoFile,'String',def_file);

load(def_file,'ico');

setappdata(hParent,'ico',ico);

set(handles.LbIcons,'String',fieldnames(ico),'Value',1)

LbIcons_Callback(handles.LbIcons,'');

%-------------------------------------------------------------------------------
  function PbBeforeRefresh_Callback(hObject,evendata)

    set(handles.PbPrevBefore,'Position',[10 10 str2double(get(handles.EdBeforeW,'String')) str2double(get(handles.EdBeforeH,'String'))])

  end

%-------------------------------------------------------------------------------
  function PbAfterView_Callback(hObject,evendata)

    cdata = get(handles.PbPrevBefore,'CData');

    picW = str2double(get(handles.EdAfterW,'String'));
    picH = str2double(get(handles.EdAfterH,'String'));

    loc = get(handles.PuLocation,'String');
    loc = loc{get(handles.PuLocation,'Value')};

    margin = str2double(get(handles.EdMargin,'String'));

    string = get(handles.EdString,'String');

    switch loc
      case 'Left'
        newDim = [size(cdata,1) picW];
        x = 1:size(cdata,1);
        y = margin + (1:size(cdata,2));
      case 'Right'
        newDim = [size(cdata,1) picW];
        x = 1:size(cdata,1);
        y = picW - margin - (size(cdata,2):-1:1) + 1;
      case 'Top'
        newDim = [picH size(cdata,2)];
        x = margin + (1:size(cdata,1));
        y = 1:size(cdata,2);
      case 'Bottom'
        newDim = [picH size(cdata,2)];
        x = picH - margin - (size(cdata,1):-1:1) + 1;
        y = 1:size(cdata,2);
    end

    cdata2 = ones(newDim)*NaN;
    cdata2 = cat(3,cdata2,cdata2,cdata2);
    cdata2(x,y,:) = cdata;

    if max(max(max(cdata2))) > 1
      cdata2 = cdata2 / 255;
    end

    set(handles.PbPrevAfter,'CData',cdata2,'Position',[10 10 picW picH],'String',string)

  end

%-------------------------------------------------------------------------------
  function PbPrevAfter_Callback(hObject,evendata)

    cdata = get(hObject,'CData');

    assignin('base','cdata',cdata);

    msgbox('The variable cdata has been created in the base workspace');

  end

%-------------------------------------------------------------------------------
  function PbLoadIcoFile_Callback(hObject,evendata)

    % Ask User to choose an icons' file
    [fileName,filePath] = uigetfile('icons/*.mat','Choose a MAT File');
    if isequal(fileName,0)
      return
    end
    fileName = fullfile(filePath,fileName);
    set(handles.EdIcoFile,'String',fileName)

    data = load(fileName,'ico');

    setappdata(hParent,'ico',data.ico);

    set(handles.LbIcons,'String',fieldnames(data.ico),'Value',1)

    LbIcons_Callback(handles.LbIcons,'');
    
    clear data

  end

%-------------------------------------------------------------------------------
  function PbPreview_Callback(hObject,evendata)

    % Get file name
    filename = get(handles.EdIcoFile,'String');

    % Display icons
    if ~isempty(filename)
      ico_disp(filename);
    end

  end

%-------------------------------------------------------------------------------
  function LbIcons_Callback(hObject,evendata)

    defW = 35;
    defH = 35;

    ico = getappdata(hParent,'ico');

    icoName = get(hObject,'String');
    icoName = icoName{get(hObject,'Value')};

    set(handles.PbPrevBefore,'CData',ico.(icoName),'Position',[10 10 defW defH])
    set(handles.EdBeforeW,'String',defW)
    set(handles.EdBeforeH,'String',defH)

    PbAfterView_Callback(handles.PbAfterView,'');

  end

end
