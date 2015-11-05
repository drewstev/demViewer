function delete_profile(hf,evnt) %#ok

gd=guidata(hf);

if gd.nump==0
    return
end
gd.val=get(gd.selectprofile,'val');

delete(gd.pdata(gd.val).thand);
delete(gd.pdata(gd.val).phand);
gd.pdata(gd.val)=[];
gd.nump=gd.nump-1;


if gd.nump==0
    gd=rmfield(gd,'pdata');
    set(gd.editprofile,'enable','off');
    set(gd.deleteprofile,'enable','off');
    set(gd.deleteallp,'visible','off');
    set(gd.selectprofile,'string','None');
    set(gd.plotprofile,'enable','off')
    set(gd.savep,'visible','off')
    guidata(hf,gd)
else
    
    pnums=num2cell(1:gd.nump);
    [gd.pdata(:).pnum]=deal(pnums{:});
    names=cellfun(@(x)(sprintf('%0.0f',x)),...
        pnums,'un',0);
   
    
    thands=arrayfun(@(x)(x.thand),gd.pdata,'un',0);
    for i=1:length(thands)
    set(thands{i},'string',names{i}')
    end
    
    set(gd.selectprofile,'string',names,'value',gd.nump)
    guidata(hf,gd)
    select_profile(hf)
end

