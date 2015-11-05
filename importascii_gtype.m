function importascii_gtype(hf2,evnt)

gd2=guidata(hf2);

val=get(gd2.gtype,'val');
switch val
    case 2
        set(gd2.prj,'enable','off')
        set(gd2.zonestr,'enable','off')
        set(gd2.hunits,'string','degrees',...
            'enable','off','value',1)
    case 1
        set(gd2.prj,'enable','on')
        set(gd2.zonestr,'enable','on')
        set(gd2.hunits,'string',{'m';'ft';'US Survey ft'},...
            'value',1,...
            'enable','on')
end
