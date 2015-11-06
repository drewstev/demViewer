function scrollfcn(hf,evnt) %#ok

gd=guidata(hf);
mousenew = get(gd.ax1,'CurrentPoint');
xy=mousenew(1,1:2);
xl=get(gd.ax1,'xlim');
yl=get(gd.ax1,'ylim');

xrange=diff(xl);
yrange=diff(yl);
gd.xlims=[xy(1)-(xrange/2) xy(1)+(xrange/2)];
gd.ylims=[xy(2)-(yrange/2) xy(2)+(yrange/2)];



guidata(hf,gd);
optimize_view(hf)

gd=guidata(hf);
set(gd.ph,'xdata',gd.xs,...
    'ydata',gd.ys,...
    'zdata',zeros(size(gd.zs)),...
    'cdata',gd.hs);
set(gd.ax1,'xlim',gd.xlims,'ylim',gd.ylims);


set(gd.str,'string',['Displaying ',gd.filename, '  Resolution = ',...
    sprintf('%0.0f m',gd.res)],...
    'foregroundcolor','k')
gd.jObj.stop
guidata(hf,gd);

