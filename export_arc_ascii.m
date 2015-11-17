function export_arc_ascii(hf,evnt) %#ok

gd=guidata(hf);


[filename, pathname] = uiputfile( ...
    {'*.asc', 'ARC ASCII Files (*.ASC)'},...
    'Save Grid',gd.outpath);

if filename==0
    return
end

switch gd.meta.ptype
    case 'cartesian'
        arcgridwrite([pathname,filename],gd.xs(1,:),gd.ys(:,1),gd.zs);
    case 'spherical'
        arcgridwrite([pathname,filename],gd.xs(1,:),gd.ys(:,1),gd.zs,...
            'precision',6);
end

guidata(hf,gd);