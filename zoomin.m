function zoomin(hf,evnt) %#ok

gd=guidata(hf);
xl=get(gd.ax1,'xlim');
yl=get(gd.ax1,'ylim');
xr=diff(xl);
yr=diff(yl);

gd.xlims=[xl(1)+(0.25*xr) xl(2)-(0.25*xr)];
gd.ylims=[yl(1)+(0.25*yr) yl(2)-(0.25*yr)];


guidata(hf,gd);
optimize_view(hf)

gd=guidata(hf);
set(gd.ph,'xdata',gd.xs,...
    'ydata',gd.ys,...
    'zdata',zeros(size(gd.zs)),...
    'cdata',gd.hs);
set(gd.ax1,'xlim',gd.xlims,'ylim',gd.ylims);

set(gd.zoom,'backgroundcolor',[0.9255    0.9137    0.8471]);

set(gd.str,'string',['Displaying ',gd.filename, '  Resolution = ',...
    sprintf(gd.fmt,gd.res),' ',gd.meta.horiz_units],...
    'foregroundcolor','k')
gd.jObj.stop
guidata(hf,gd);

