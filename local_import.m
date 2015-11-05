function local_import(hf,evnt) %#ok

gd=guidata(hf);

% [filename, pathname] = uigetfile( ...
%     {'*.*', 'ARC ASCII Files (*.*)'},...
%     'Select an ARC ASCII File',gd.guipath);
% 
% if filename==0
%     return
% end

%remove previous metadata
if isfield(gd,'meta');
    gd=rmfield(gd,'meta');
end

meta=importascii;

set(gd.str,'string',...
    'Converting ARC ASCII file to NetCDF, Please Wait...',...
    'foregroundcolor','r')
gd.jObj.start
drawnow


arcascii2nc(meta)

filename=[strtok(meta.filename,'.'),'.nc'];
gd.x=ncread([meta.pathname,filename],'x');
gd.y=ncread([meta.pathname,filename],'y');
gd.x_resolution=mode(diff(gd.x));
gd.y_resolution=mode(diff(gd.y));
fun=@(x)([min(x) max(x)]);
gd.xo=fun(gd.x);
gd.yo=fun(gd.y);
gd.xlims=gd.xo;
gd.ylims=gd.yo;
gd.meta=meta;

gd.guipath=meta.pathname;
gd.filename=filename;
gd.ftype=1;


if gd.x_resolution<1
    sigdig=length(num2str(floor(1/gd.x_resolution)));
    gd.fmt=['%0.',sprintf('%0.0f',sigdig),'f',''];
else
    gd.fmt='%0.0f';
end

guidata(hf,gd);

optimize_view(hf);

hillshade_bathy(hf);
plot_overview(hf);

set(gd.ax1,'visible','on')
set(gd.options,'visible','on')
set(gd.zoom,'enable','on')
set(gd.zoomin,'enable','on')
set(gd.zoomout,'enable','on')
set(gd.reset,'enable','on')
set(gd.toolbar,'visible','on')
set(gd.panel1,'visible','on')
set(gd.mexport,'visible','on')
set(gd.vmeta,'visible','on')


