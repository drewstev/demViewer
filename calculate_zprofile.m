function calculate_zprofile(hf,gd) %#ok

gd=guidata(hf);
gd.val=get(gd.selectprofile,'value');
%calculate profile values
switch gd.meta.ptype
    case 'cartesian'
        xd=diff(gd.pdata(gd.val).x);
        yd=diff(gd.pdata(gd.val).y);
        tdist=sqrt(xd.^2+yd.^2);
        gd.pdata(gd.val).dist=(0:gd.x_resolution:tdist); 
        gd.pdata(gd.val).xi=linspace(gd.pdata(gd.val).x(1),...
            gd.pdata(gd.val).x(2),numel(gd.pdata(gd.val).dist));
        gd.pdata(gd.val).yi=linspace(gd.pdata(gd.val).y(1),...
            gd.pdata(gd.val).y(2),numel(gd.pdata(gd.val).dist));
    case 'spherical'
        
        xd=diff(gd.pdata(gd.val).x);
        yd=diff(gd.pdata(gd.val).y);
        pdist=sqrt(xd.^2+yd.^2);
        nvals=floor(pdist/gd.x_resolution);
        
        tdist=vdist(gd.pdata(gd.val).y(1),gd.pdata(gd.val).x(1),...
            gd.pdata(gd.val).y(2),gd.pdata(gd.val).x(2));
        
        gd.pdata(gd.val).dist=linspace(0,tdist,nvals); 
        gd.pdata(gd.val).xi=linspace(gd.pdata(gd.val).x(1),...
            gd.pdata(gd.val).x(2),numel(gd.pdata(gd.val).dist));
        gd.pdata(gd.val).yi=linspace(gd.pdata(gd.val).y(1),...
            gd.pdata(gd.val).y(2),numel(gd.pdata(gd.val).dist));
end
%use nearest grid point for now
fun=@(x,y)(find(x>=y(1) & x<=y(2)));
xv=fun(gd.x,sort(gd.pdata(gd.val).x));
yv=fun(gd.y,sort(gd.pdata(gd.val).y));


xidx=zeros(1,numel(gd.pdata(gd.val).xi));
yidx=zeros(1,numel(gd.pdata(gd.val).yi));
for i=1:length(xidx)
    [~,xidx(i)]=min(abs(gd.x(xv)-(gd.pdata(gd.val).xi(i))));
    [~,yidx(i)]=min(abs(gd.y(yv)-(gd.pdata(gd.val).yi(i))));
end


switch gd.ftype
    case 1
        zfr=ncread([gd.guipath,gd.filename],'z',...
            [yv(1) xv(1)],[numel(yv) numel(xv)],[1 1]);
        zfr(zfr==1000000)=NaN;
        zidx=sub2ind(size(zfr),yidx,xidx);
        
    case 2
        zfr=double(h5read([gd.guipath,gd.filename],'/BAG_root/elevation',...
            [xv(1) yv(1)],[numel(xv) numel(yv)],[1 1])');
      
            zidx=sub2ind(size(zfr),yidx,xidx);
    
    minz = h5readatt([gd.guipath,gd.filename],...
        '/BAG_root/elevation','Minimum Elevation Value');
    maxz = h5readatt([gd.guipath,gd.filename],...
        '/BAG_root/elevation','Maximum Elevation Value');
    zfr(zfr<minz | zfr>maxz)=NaN;

end


[gx,gy]=meshgrid(gd.x(xv),gd.y(yv));

gd.pdata(gd.val).xi=gx(zidx);
gd.pdata(gd.val).yi=gy(zidx);
gd.pdata(gd.val).zi=zfr(zidx);

guidata(hf,gd);