function edit_profile(hf,evnt) %#ok

gd=guidata(hf);

gd.val=get(gd.selectprofile,'val');
set(gcf,'pointer','cross');

waitforbuttonpress
xy=get(gd.ax1,'currentpoint');
%have to figure out which point to edit

xd=gd.pdata(gd.val).x-xy(2,1);
yd=gd.pdata(gd.val).y-xy(2,2);
[~,gd.pedit]=min(sqrt(xd.^2+yd.^2));

set(gcf,'WindowButtonMotionFcn',@emotion)
set(gcf,'WindowButtonUpFcn',@edone);


guidata(hf,gd)
uiwait

calculate_zprofile(hf)


%%%%---------------------------------------

function emotion(hf,evnt) %#ok
%LMOTION- callback for buttondown
gd=guidata(hf);

xy=get(gd.ax1,'currentpoint');

gd.pdata(gd.val).x(gd.pedit)=xy(1,1);
gd.pdata(gd.val).y(gd.pedit)=xy(1,2);
set(gd.pdata(gd.val).phand,'xdata',gd.pdata(gd.val).x,...
    'ydata',gd.pdata(gd.val).y);
if gd.pedit==1
    set(gd.pdata(gd.val).thand,'position',...
        [gd.pdata(gd.val).x(1),gd.pdata(gd.val).y(1), 0]);
end
guidata(hf,gd);


%%%%---------------------------------------------
function edone(hf,evnt) %#ok
%LDONE- callback for buttonup
gd=guidata(hf);


set(gcf,'pointer','arrow');
set(gcf,'WindowButtonMotionFcn',[]);
set(gcf,'WindowButtonUpFcn',[]);

%remove analysis, if present from BFGUI if profile is edited
afields={'zf';...
    'cidx';...
    'tidx';...
    'cz';...
    'tz';...
    'bf'};
for i=1:length(afields)
    if isfield(gd.pdata(gd.val),afields{i});
        gd.pdata(gd.val).(afields{i})=[];
    end
end

guidata(hf,gd);
uiresume