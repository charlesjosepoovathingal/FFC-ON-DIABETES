function fig = buildFileManager()

% File Manager
fig = figure('Name','File Manager','NumberTitle','off',...
    'MenuBar','none','ToolBar','none','Units','normalized',...
    'Position',[0 0.1 0.24 0.75],'Tag','fig');

% +uitable
uitable(fig,...
            'RowName',[],...
            'RowStriping','on',...
            'ColumnName',{'','Dataset','Sequence','File'},...
            'ColumnWidth',{40,100,100,80},...
            'ColumnEditable',true,...
            'Units','normalized',...
            'Position',[0 0 1 1],...
            'Tag','table');
end

