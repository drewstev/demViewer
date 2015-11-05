function save_profiles(hf,evnt) %#ok

gd=guidata(hf);


[filename, pathname] = uiputfile( ...
    {'*.mat', 'MAT Files (*.mat)'},...
    'Save Profiles As',gd.outpath);

if filename==0
    return
end
pdata=rmfield(gd.pdata,{'phand';'thand'}); %#ok
save([pathname,filename],'pdata')

gd.outpath=pathname;
guidata(hf,gd);