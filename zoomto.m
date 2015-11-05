function zoomto(hf,evnt)%#ok

gd=guidata(hf);
set(gd.zoom,'backgroundcolor','g');
set(gcf,'pointer','cross')

k=waitforbuttonpress; %#ok
point1 = get(gca,'CurrentPoint');
finalRect = rbbox; %#ok
point2 = get(gca,'CurrentPoint');
point1 = point1(1,1:2);
point2 = point2(1,1:2);
if isequal(point1,point2)
    set(gcf,'pointer','arrow')
    msgbox('To zoom, click and hold mouse button while defining rectangle')
    set(gd.zoom,'backgroundcolor',[0.9255    0.9137    0.8471]);
    return
end

set(gcf,'pointer','arrow')
gd.xlims=sort([point1(1),point2(1)]);
gd.ylims=sort([point1(2),point2(2)]);

guidata(hf,gd);
optimize_view(hf)

gd=guidata(hf);
set(gd.ph,'xdata',gd.xs(1,:),...
    'ydata',gd.ys(:,1),...
    'zdata',zeros(size(gd.zs)),...
    'cdata',gd.hs);
set(gd.ax1,'xlim',gd.xlims,'ylim',gd.ylims);

set(gd.zoom,'backgroundcolor',[0.9255    0.9137    0.8471]);

set(gd.str,'string',['Displaying ',gd.filename, '  Resolution = ',...
    sprintf(gd.fmt,gd.res),' ',gd.meta.horiz_units],...
    'foregroundcolor','k')
gd.jObj.stop

guidata(hf,gd);
