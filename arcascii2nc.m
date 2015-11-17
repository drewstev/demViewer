function arcascii2nc(meta)

%read the metadata
if ~exist('arcgridread','file')
    [x,y,z] = arc_asc_read([meta.pathname,meta.filename]);
    x=x-diff(x(1:2))/2; %x and y should be on corners, not centers
    y=y+diff(y(1:2))/2;
else
    [z,r]=arcgridread([meta.pathname,meta.filename]);
    [x,y]=pixcenters(r,size(z)); 
    %x and y should be on grid corners, not centers
    x=x-diff(x(1:2))/2;
    y=y+diff(y(1:2))/2;
    
    
end

[path,file,ext]=fileparts([meta.pathname,meta.filename]); %#ok
ncid = netcdf.create([path,filesep,file,'.nc'],'clobber');
xdim=netcdf.defDim(ncid,'x',numel(x));
ydim=netcdf.defDim(ncid,'y',numel(y));

varid = netcdf.getConstant('GLOBAL');
netcdf.putAtt(ncid,varid,'pathname',meta.pathname);
netcdf.putAtt(ncid,varid,'filename',meta.filename);
netcdf.putAtt(ncid,varid,'projection',meta.projection);
netcdf.putAtt(ncid,varid,'zone',meta.zone);
netcdf.putAtt(ncid,varid,'horiz_datum',meta.horiz_datum);
netcdf.putAtt(ncid,varid,'vert_datum',meta.vert_datum);
netcdf.putAtt(ncid,varid,'ptype',meta.ptype);
netcdf.putAtt(ncid,varid,'horiz_units',meta.horiz_units);
netcdf.putAtt(ncid,varid,'vert_units',meta.vert_units);


vx=netcdf.defVar(ncid,'x','double',...
    xdim);
vy=netcdf.defVar(ncid,'y','double',...
    ydim);
vz=netcdf.defVar(ncid,'z','double',...
    [ydim xdim]);
    
netcdf.endDef(ncid);

netcdf.putVar(ncid,vx,x);
netcdf.putVar(ncid,vy,y);
netcdf.putVar(ncid,vz,z);
netcdf.close(ncid)