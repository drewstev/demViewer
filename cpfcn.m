function cpfcn(hf,evnt)

switch evnt.Character
    case 'z'
        zoomto(hf)
    case 'f'
        reset_zoom(hf)
    case '='
        zoomin(hf)
    case '-'
        zoomout(hf)
    case 'n'
        new_profile(hf);
    case 'd'
        delete_profile(hf);
    case 'e'
        edit_profile(hf);
    case 'p'
       plot_profile(hf);
end