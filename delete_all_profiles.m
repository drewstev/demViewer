function delete_all_profiles(hf,evnt) %#ok

gd=guidata(hf);

butt=questdlg('Confirm delete all profiles',...
    'delete','Yes','No','Yes');

switch butt
    case 'Yes'
        for i =1:length(gd.pdata)
            delete(gd.pdata(i).thand);
            delete(gd.pdata(i).phand);
        end
        gd.nump=0;
        gd=rmfield(gd,'pdata');
        set(gd.editprofile,'enable','off');
        set(gd.deleteprofile,'enable','off');
        set(gd.deleteallp,'visible','off');
        
        set(gd.plotprofile,'enable','off')
        set(gd.savep,'visible','off')
        guidata(hf,gd)
        set(gd.selectprofile,'string','None',...
            'enable','off','value',1);
end

