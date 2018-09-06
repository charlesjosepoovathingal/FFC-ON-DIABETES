%% Password
%   Copyright 2017-2018 The MathWorks, Inc.

%% Create the widget

f = figure(...
    'Toolbar','none',...
    'MenuBar','none',...
    'NumberTitle','off',...
    'Units','pixels',...
    'Position',[100 100 320 45]);
movegui(f,[100 -100])

w = uiw.widget.Password(...
    'Parent',f,...
    'Value','abc',...
    'Callback',@(h,e)disp(e),...
    'Label','Password:',...
    'LabelLocation','left',...
    'LabelWidth',90,...
    'Units','pixels',...
    'Position', [10 10 300 25]);

