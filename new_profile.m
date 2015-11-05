function new_profile(hf,evnt) %#ok

pdata=draw_profile(hf);
gd=guidata(hf);

gd.val=get(gd.selectprofile,'val');
if isfield(gd,'pdata')
    afields={'zf';...
        'cidx';...
        'tidx';...
        'cz';...
        'tz';...
        'bf'};
    for i=1:length(afields)
        if isfield(gd.pdata(gd.val),afields{i});
            pdata.(afields{i})=[];
        end
    end
    gd.pdata=orderfields(gd.pdata,pdata);
end

gd.pdata(gd.nump)=pdata;

if gd.nump>1
    set(gd.selectprofile,'enable','on')
    phands=arrayfun(@(x)(x.phand),gd.pdata(1:gd.nump-1),'un',0);
    thands=arrayfun(@(x)(x.thand),gd.pdata(1:gd.nump-1),'un',0);
    for i=1:length(phands)
        set(phands{i},'color','k')
    end
    for i=1:length(thands)
        set(thands{i},'color','k')
    end
end
    
pnums=arrayfun(@(x)(x.pnum),gd.pdata);
names=cellfun(@(x)(sprintf('%0.0f',x)),...
    num2cell(pnums),'un',0);

set(gd.selectprofile,'string',names,'value',gd.nump)
guidata(hf,gd);
calculate_zprofile(hf)


set(gd.editprofile,'enable','on')
set(gd.deleteprofile,'enable','on')
set(gd.plotprofile,'enable','on')
set(gd.deleteallp,'visible','on','enable','on');
set(gd.savep,'visible','on')
