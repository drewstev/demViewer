function reset_zoom(hf,evnt) %#ok

gd=guidata(hf);
gd.xlims=gd.xo;
gd.ylims=gd.yo;
gd.zs=gd.zf;
gd.xs=gd.xf;
gd.ys=gd.yf;
guidata(hf,gd)
% optimize_view(hf);
hillshade_bathy(hf);

gd=guidata(hf);
set(gd.ph,'xdata',gd.xf(1,:),...
    'ydata',gd.yf(:,1),...
    'zdata',zeros(size(gd.zf)),...
    'cdata',gd.hs);
set(gd.ax1,'xlim',gd.xo,'ylim',gd.yo);

set(gd.str,'string',['Displaying ',gd.filename, '  Resolution = ',...
    sprintf(gd.fmt,diff(gd.xs(1,1:2))),' ',gd.meta.horiz_units],...
    'foregroundcolor','k')

gd.jObj.stop