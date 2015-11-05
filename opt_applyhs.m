function opt_applyhs(hf2,evnt) %#ok

gd2=guidata(hf2);
val=get(gd2.applyhs,'value');
switch val
    case 1
            set(gd2.azi,'enable','on')
    set(gd2.zfac,'enable','on')
    set(gd2.alt,'enable','on')
    case 0
            set(gd2.azi,'enable','off')
    set(gd2.zfac,'enable','off')
    set(gd2.alt,'enable','off')
end