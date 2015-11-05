function view_metadata(hf,evnt) %#ok

gd=guidata(hf);

if ~isfield(gd,'meta')
    msgbox(['No metadata exists for this file. Use File-Import to ',...
        'provide metadata about this file']);
    return
else
    fields=fieldnames(gd.meta);
    data=cell(length(fields),2);
    data(:,1)=fields;
    data(:,2)=struct2cell(gd.meta);
end
    
        
h2=figure;
set(h2,'Name','Line Info','menubar','none','numbertitle','off');


mtable=uitable(h2,'Data',data,'columnname',{'Property','Value'});
set(mtable,'units','normalized','position',[0.1 0.25 0.8 0.75]);

pix=get(h2,'position');
cwidth=floor([0.3 0.45]*pix(3));
set(mtable,'columnwidth',num2cell(cwidth))