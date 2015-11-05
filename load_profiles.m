function load_profiles(hf,evnt) %#ok

gd=guidata(hf);


[filename, pathname] = uigetfile( ...
    {'*.mat', 'MAT Files (*.mat)'},...
    'Select a MAT File',gd.ppath);

if filename==0
    return
end



pdata=load([pathname,filename]);

if isfield(gd,'pdata')
    %if profile exist first remove the plot
    for i =1:length(gd.pdata)
        delete(gd.pdata(i).thand);
        delete(gd.pdata(i).phand);
    end
    
    %if profiles already exist, renumber the loaded ps
    pnums=num2cell((1:length(pdata.pdata))+gd.nump);
    [pdata.pdata(:).pnum]=deal(pnums{:});
    gd.nump=gd.nump+length(pdata.pdata);
    
    %make sure fields are consistent
    ofields=fieldnames(gd.pdata);
    nfields=fieldnames(pdata.pdata);
    cfields=unique(cat(1,ofields,nfields));
    for i=1:length(cfields)
        if ~isfield(pdata.pdata,cfields{i})
            junk=cell(length(pdata.pdata),1);
            [pdata.pdata(:).(cfields{i})]= deal(...
                junk{:});
        end
   
        if ~isfield(gd.pdata,cfields{i})
            junk=cell(length(gd.pdata),1);
            [gd.pdata(:).(cfields{i})]= deal(...
                junk{:});
        end
    end
    pdata.pdata = orderfields(pdata.pdata, gd.pdata);
    gd.pdata=[gd.pdata,pdata.pdata];
else


    gd.pdata=pdata.pdata;
    gd.nump=length(gd.pdata);
end

hold on
ph=arrayfun(@(x)(plot(x.x,x.y,'k+-')),...
    gd.pdata,'un',0);
th=arrayfun(@(x)(text(x.x(1),x.y(1),sprintf('%0.0f',x.pnum),...
    'verticalalign','top')),gd.pdata,'un',0);
[gd.pdata(:).phand]=deal(ph{:});
[gd.pdata(:).thand]=deal(th{:});

set(gd.pdata(gd.nump).thand,'color','r');
set(gd.pdata(gd.nump).phand,'color','r');

pnums=arrayfun(@(x)(x.pnum),gd.pdata);
names=cellfun(@(x)(sprintf('%0.0f',x)),...
    num2cell(pnums),'un',0);


set(gd.selectprofile,'string',names,'value',length(gd.pdata))
 set(gd.selectprofile,'enable','on')
set(gd.editprofile,'enable','on')
set(gd.deleteprofile,'enable','on')
set(gd.deleteallp,'visible','on','enable','on');
set(gd.plotprofile,'enable','on')
set(gd.savep,'visible','on')

guidata(hf,gd)
