function hillshade_bathy(hf,evnt) %#ok

gd=guidata(hf);
set(gd.str,'string',...
    'Processing DEM',...
    'foregroundcolor','r')
drawnow


flag=isfinite(gd.zs);

if ~isempty(gd.cmap) %in case hillshade only
zrgb2=real2rgb(gd.zs,...
    gd.cmap,gd.clims);
else 
    [m,n]=size(gd.zs);
    zrgb2=ones(m,n,3);
end

if gd.hseffect % in case no hillshad
    hs=hillshade(gd.zs,...
        gd.xs(1,:),...
        gd.ys(:,1),...
        'azimuth',gd.azimuth,...
        'altitude',gd.altitude,...
        'zfactor',gd.zfactor);
    hflag=isfinite(hs);
    aflag=all(cat(3,flag,hflag),3);
    
    hsr=real2rgb(hs,'gray');
    rh=hsr(:,:,1);
    gh=hsr(:,:,2);
    bh=hsr(:,:,3);
    rh(~aflag)=NaN;
    gh(~aflag)=NaN;
    bh(~aflag)=NaN;
    
    if ~isempty(gd.cmap)
    r=zrgb2(:,:,1);
    g=zrgb2(:,:,2);
    b=zrgb2(:,:,3);
    r(~aflag)=NaN;
    g(~aflag)=NaN;
    b(~aflag)=NaN;
    zrgb2=cat(3,r,g,b);
    end
else
    r=zrgb2(:,:,1);
    g=zrgb2(:,:,2);
    b=zrgb2(:,:,3);
    r(~flag)=NaN;
    g(~flag)=NaN;
    b(~flag)=NaN;
    zrgb2=cat(3,r,g,b);
end
    

if isfield(gd,'xf')
    if gd.hseffect
        gd.hs=cat(3,rh,gh,bh).*zrgb2;
    else
        gd.hs=zrgb2;
    end
    
else
    gd.xf=gd.xs;
    gd.yf=gd.ys;
    gd.zf=gd.zs;
    if gd.hseffect
        gd.hs=cat(3,rh,gh,bh).*zrgb2;
    else
        gd.hs=zrgb2;
    end
end



guidata(hf,gd);