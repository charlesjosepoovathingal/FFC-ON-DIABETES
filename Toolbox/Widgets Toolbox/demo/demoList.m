%% List
%   Copyright 2017-2018 The MathWorks, Inc.

%% Create the widget

f = figure(...
    'Toolbar','none',...
    'MenuBar','none',...
    'NumberTitle','off',...
    'Units','pixels',...
    'Position',[100 100 120 220]);
movegui(f,[100 -100])

w = uiw.widget.List(...
    'Parent', f, ...
    'Items',{'Alpha','Bravo','Charlie','Delta','Echo','Foxtrot'},...
    'Label','Names:', ...
    'LabelLocation','top',...
    'LabelHeight',18,...
    'Callback',@(h,e)disp(e.Interaction),...
    'Units', 'pixels', ...
    'Position', [10 10 100 200]);


%% Set by index

w.AllowMultiSelect = true;
w.SelectedIndex = [3 5];


%% Get the selected items 

% This is a read-only property
selection = w.SelectedItems