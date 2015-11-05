function export_mat(hf,evnt) %#ok

gd=guidata(hf);


[filename, pathname] = uiputfile( ...
    {'*.mat', 'MAT Files (*.MAT)'},...
    'Save Profiles As',gd.outpath);

if filename==0
    return
end

x=gd.xs; %#ok
y=gd.ys; %#ok
z=gd.zs; %#ok
hs=gd.hs; %#ok

hs_settings.clim=gd.clims;
hs_settings.cmap=gd.cmap;
hs_settings.azimuth=gd.azimuth;
hs_settings.zfactor=gd.zfactor; %#ok



save([pathname,filename],'x','y','z','hs','hs_settings')

gd.outpath=pathname;
guidata(hf,gd)
