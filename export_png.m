function export_jpeg(hf,evnt) %#ok

gd=guidata(hf);


[filename, pathname] = uiputfile( ...
    {'*.png', 'PNG Files (*.PNG)'},...
    'Save Profiles As',gd.outpath);

if filename==0
    return
end





if diff(gd.ys(1:2,1))<0
    rgb=gd.hs;
    
else
    rgb=zeros(size(gd.hs));
    for i=1:size(gd.hs,3);
        rgb(:,:,i)=flipud(gd.hs(:,:,i));
    end
end

trans=double(all(isfinite(rgb),3));

v=ver;
if ~any(strcmpi('Mapping Toolbox',{v(:).Name}'));
    fid=fopen([pathname,strtok(filename,'.'),'.pgw'],'wt');
    fprintf(fid,'%0.2f\n',gd.res);
    fprintf(fid,'%0.2f\n%0.2f\n',0,0);
    fprintf(fid,'%0.2f\n',-gd.res);
    fprintf(fid,'%0.3f\n',gd.xs(1));
    fprintf(fid,'%0.3f',gd.ys(1));
    fclose(fid);
    
    
else
    
    switch gd.meta.ptype
        case 'cartesian'
            R=makerefmat(gd.xs(1)+(gd.res/2),...
                gd.ys(1)-(gd.res/2),gd.res,-gd.res); %these are cell centers
        case 'spherical'
            R=makerefmat('RasterSize',size(gd.zs),...
                'LatitudeLimits',[min(gd.xs(:)) max(gd.xs(:))],...
                'LongitudeLimits',[min(gd.ys(:)) max(gd.ys(:))]);
    end
    
    worldfilewrite(R,[pathname,strtok(filename,'.'),'.pgw']);
end

imwrite(rgb,[pathname,filename],'alpha',trans)
