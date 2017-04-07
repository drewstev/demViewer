function local_apply(hf2,evnt) %#ok


gd2=guidata(hf2);
hf=gd2.hf;
gd=guidata(gd2.hf);

clow=str2double(get(gd2.editlow,'string'));
chigh=str2double(get(gd2.edithigh,'string'));
gd.clims=[clow chigh];

gd.cval=get(gd2.pop,'value');

switch gd.cval
    case 1
        gd.cmap=jet(30);
    case 2
        gd.cmap=cptcmap('GMT_ocean','ncol',30);
    case 3
        gd.cmap=cptcmap('GMT_haxby','ncol',30);
    case 4
        gd.cmap=cptcmap('GMT_globe','ncol',30);
    case 5
        gd.cmap=cptcmap('GMT_gray','ncol',30);
    case 6
        gd.cmap=cptcmap('GMT_drywet','ncol',30);
    case 7
        gd.cmap=cptcmap('GMT_relief_oceanonly','ncol',30);
    case 8
        gd.cmap=cptcmap('GMT_relief','ncol',30);
    case 9
        gd.cmap=cptcmap('GMT_no_green','ncol',30);
    case 10
        ameland=load('ameland');
        gd.cmap=ameland.map;
    case 11
        sgmap=load('sgmap');
        gd.cmap=sgmap.sgmap;
    case 12
        gd.cmap=[];
end

gd.invertcmap=get(gd2.cmap_invert,'value');
if gd.invertcmap
    gd.cmap=flipud(gd.cmap);
end

gd.hseffect=get(gd2.applyhs,'value');
gd.azimuth=str2double(get(gd2.azi,'string'));
gd.altitude=str2double(get(gd2.alt,'string'));
gd.zfactor=str2double(get(gd2.zfac,'string'));


guidata(hf,gd);
hillshade_bathy(hf);


gd=guidata(hf);
set(gd.fig,'colormap',gd.cmap)
set(gd.ph,'xdata',gd.xs,...
    'ydata',gd.ys,...
    'zdata',zeros(size(gd.zs)),...
    'cdata',gd.hs);

set(gd.ax1,'xlim',gd.xlims,'ylim',gd.ylims,...
    'clim',gd.clims);

set(gd.zoom,'backgroundcolor',[0.9255    0.9137    0.8471]);

if isempty(gd.cmap)
    set(gd.c1,'visible','off')
else
    set(gd.c1,'visible','on')
end

set(gd.str,'string',['Displaying ',gd.filename, '  Resolution = ',...
    sprintf(gd.fmt,gd.res),' ',gd.meta.horiz_units],...
    'foregroundcolor','k')



guidata(hf,gd)




