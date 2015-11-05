function optimize_view(hf,evnt) %#ok

gd=guidata(hf);
gd.jObj.start;
set(gd.str,'string',...
    'Reading DEM Data',....
    'foregroundcolor','r')
drawnow
fun=@(x,y)(find(x>=y(1) & x<=y(2)));
xv=fun(gd.x,gd.xlims);
yv=fun(gd.y,gd.ylims);

%figure out the display resolution 
res=max([numel(xv);...
    numel(yv)].*gd.x_resolution./gd.maxgrd);

if res<gd.x_resolution
    res=gd.x_resolution;
end

stride=floor(res/gd.x_resolution);
xcount=floor(numel(xv)/stride);
ycount=floor(numel(yv)/stride);

switch gd.ftype
    case 1
        xs=gd.x(xv(1):stride:xv(1)+((xcount-1)*stride));
        ys=gd.y(yv(1):stride:yv(1)+((ycount-1)*stride));
        gd.zs=ncread([gd.guipath,gd.filename],'z',...
            [yv(1) xv(1)],[ycount xcount],[stride stride]);
        gd.zs(gd.zs==1000000)=NaN;
        
    case 2
        xs=gd.x(xv(1):stride:xv(1)+((xcount-1)*stride));
        ys=gd.y(yv(1):stride:yv(1)+((ycount-1)*stride));
        gd.zs=double(h5read([gd.guipath,gd.filename],'/BAG_root/elevation',...
            [xv(1) yv(1)],[xcount ycount],[stride stride])');
      
            
    
    minz = h5readatt([gd.guipath,gd.filename],...
        '/BAG_root/elevation','Minimum Elevation Value');
    maxz = h5readatt([gd.guipath,gd.filename],...
        '/BAG_root/elevation','Maximum Elevation Value');
    gd.zs(gd.zs<minz | gd.zs>maxz)=NaN;

end

[gd.xs,gd.ys]=meshgrid(xs,ys);

if ~isfield(gd,'clims')
    gd.clims=[min(gd.zs(:)) max(gd.zs(:))];
end

gd.res=stride.*gd.x_resolution;

guidata(hf,gd);
hillshade_bathy(hf);


