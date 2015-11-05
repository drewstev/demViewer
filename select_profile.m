function select_profile(hf,evnt) %#ok

gd=guidata(hf);
phands=arrayfun(@(x)(x.phand),gd.pdata,'un',0);
thands=arrayfun(@(x)(x.thand),gd.pdata,'un',0);

for i=1:length(phands)
    set(phands{i},'color','k')
end
for i=1:length(thands)
    set(thands{i},'color','k')
end

val=get(gd.selectprofile,'value');
set(phands{val},'color','r')
set(thands{val},'color','r')
