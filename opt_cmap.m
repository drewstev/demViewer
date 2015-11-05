function opt_cmap(hf2,evnt) %#ok

gd2=guidata(hf2);

val=get(gd2.pop,'value');
if val==11
    set(gd2.applyhs,'value',1)
    set(gd2.azi,'enable','on')
    set(gd2.zfac,'enable','on')
    set(gd2.alt,'enable','on')
    set(gd2.cmap_invert,'enable','off')
    set(gd2.editlow,'enable','off')
    set(gd2.edithigh,'enable','off')
else
        set(gd2.cmap_invert,'enable','on')
    set(gd2.editlow,'enable','on')
    set(gd2.edithigh,'enable','on')
end
