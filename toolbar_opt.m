function toolbar_opt(hf,evnt) %#ok

gd=guidata(hf);
if gd.tools==1;
    gd.tools=0;
    set(gd.toolbar,'label','Show Control Panel');
    set(gd.panel1,'visible','off')
    set(gd.ax1,'position',[0.0888 0.097 0.817 0.8317]);
else
    gd.tools=1;
    set(gd.toolbar,'label','Hide Control Panel');
    set(gd.panel1,'visible','on')
    set(gd.ax1,'position',[0.0888 0.321 0.817 0.607]); 
end

guidata(hf,gd);
