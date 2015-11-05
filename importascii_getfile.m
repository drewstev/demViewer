function importascii_getfile(hf2,evnt)


gd2=guidata(hf2);

[filename, pathname] = uigetfile( ...
    {'*.*', 'ARC ASCII Files (*.*)'},...
    'Select an ARC ASCII File');

if filename==0
    return
end


gd2.guipath=pathname;
gd2.filename=filename;
set(gd2.filestr,'string',...
    filename);
set(gd2.doimport,'enable','on')
guidata(hf2,gd2);

