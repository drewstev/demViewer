function plot_overview(hf,evnt) %#ok

gd=guidata(hf);
gd.ph=surf(gd.xs(1,:),...
    gd.ys(:,1),...
    zeros(size(gd.zs)),gd.hs,...
    'parent',gd.ax1);
shading flat
    
set(gca,'xlim',gd.xo,...
    'ylim',gd.yo,...
    'ydir','n',...
    'da',[1 1 200],...
    'xaxislocation','top',...
    'clim',gd.clims,...
    'view',[0 90])

colormap(gd.cmap)
gd.c1=colorbar;
set(get(gd.c1,'ylabel'),'string',['\bf\itElevation (',gd.meta.vert_units,...
    ')']);

set(gd.str,'string',['Displaying ',gd.filename, '  Resolution = ',...
    sprintf(gd.fmt,gd.res),' ',gd.meta.horiz_units],...
    'foregroundcolor','k')
gd.jObj.stop
guidata(hf,gd);