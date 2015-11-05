function export_xyz(hf,evnt) %#ok

gd=guidata(hf);


[filename, pathname] = uiputfile( ...
    {'*.xyz', 'XYZ Files (*.xyz)'},...
    'Save Profiles As',gd.outpath);

if filename==0
    return
end

x=gd.xs(:);
y=gd.ys(:);
z=gd.zs(:);
xyz=[x y z];
xyz(any(isnan(xyz),2),:)=[];
dlmwrite([pathname,filename],xyz,'delimiter',' ',...
    'precision','%0.2f');

gd.outpath=pathname;
guidata(hf,gd)


