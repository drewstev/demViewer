function pdata=draw_profile(hf,evnt) %#ok

gd=guidata(hf);
gd.nump=gd.nump+1;
hf2=get(gd.ax1,'parent');

gd.told=get(gd.str,'string');
set(gd.str,'string',...
    'Click and drag to draw profile',...
    'foregroundcolor','r');
        

waitforbuttonpress;

cc = get(gd.ax1,'CurrentPoint');
gd.xy1 = cc(1,1:2);
hold on
gd.t1=text(gd.xy1(1),gd.xy1(2),num2str(gd.nump),...
    'verticalalign','top','color','r');


guidata(hf,gd)

set(hf2,'WindowButtonMotionFcn',@lmotion);
set(hf2,'WindowButtonUpFcn',@ldone);


uiwait
gd=guidata(hf);
pdata.pnum=gd.nump;
pdata.phand=gd.phand;
pdata.thand=gd.thand;
pdata.x=[gd.xy1(1) gd.xy2(1)];
pdata.y=[gd.xy1(2) gd.xy2(2)];
pdata.xi=[];
pdata.yi=[];
pdata.zi=[];
pdata.dist=[];

%%%%--------------------------------------------------------------

function lmotion(hf,evnt) %#ok
%LMOTION- callback for buttondown
gd=guidata(hf);



mousenew = get(gd.ax1,'CurrentPoint');
gd.xy2 = mousenew(1,1:2);

xd = gd.xy2(1) - gd.xy1(1); 
yd = gd.xy2(2) - gd.xy1(2); 
dist=sqrt(xd.*xd +yd.*yd)';



if isfield(gd,'m1')
    set(gd.m1,'xdata',[gd.xy1(1) gd.xy2(1)],...
        'ydata',[gd.xy1(2) gd.xy2(2)]);
   
    
else
    gd.m1=plot([gd.xy1(1) gd.xy2(1)],...
        [gd.xy1(2) gd.xy2(2)],'marker','+');
    set(gd.m1,'color','r')
    

    
end

set(gd.str,'string',sprintf(['dx = %.1f, ',...
    'dy = %0.1f ,distance = %0.1f'],...
     xd,yd,dist));

guidata(hf,gd)

%----------------------------------------------------------

function ldone(hf,evnt) %#ok
%LDONE- callback for buttonup
gd=guidata(hf);

hf2=get(gd.ax1,'parent');

set(hf2,'WindowButtonMotionFcn',[]);
set(hf2,'WindowButtonUpFcn',[]);

set(gd.str,'string',gd.told,...
    'foregroundcolor','k')
set(hf2,'pointer','arrow')
gd.phand=gd.m1;
gd.thand=gd.t1;
gd=rmfield(gd,{'m1','t1','told'});

%now calculate the profile

guidata(hf,gd)
uiresume
