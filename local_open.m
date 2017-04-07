function local_open(hf,evnt,filename) %#ok

gd=guidata(hf);



if nargin<3
    [filename, pathname,gd.ftype] = uigetfile( ...
        {'*.nc', 'NetCDF Files (*.nc)';...
        '*.bag','Bathymetric Attributed Grid (*.bag)'},...
        'Select a File',gd.guipath);
    if isempty(filename) || isequal(filename,0)
        return;
    end
    if exist('demViewer.ini','file')
        fp=which('demViewer.ini');
        
        %first need to see if the file already exists in MRU
        fid=fopen(fp,'r');
        mrufiles=textscan(fid,'%[^\n]');
        fclose(fid);
        
        if ~ismember([pathname,filename],mrufiles{1});
            fid=fopen(fp,'a');
            fprintf(fid,'%s\n',[pathname,filename]);
            fclose(fid);
        end
    else
        [dpath,~,~]=fileparts(which('demViewer.m'));
        fid=fopen([dpath,filesep,'demViewer.ini'],'wt');
        fprintf(fid,'%s\n',[pathname,filename]);
        fclose(fid);
    end
    
    
else
    [pathname,filename,ext]=fileparts(filename);
    filename=[filename,ext];
    pathname=[pathname,filesep];
    switch ext
        case '.nc'
            gd.ftype=1;
        case '.bag'
            gd.ftype=2;
        otherwise
            error('Only .nc or .bag files can be opened')
    end
end

set(gd.ax1,'nextplot','replace')


if isfield(gd,'meta');
    gd=rmfield(gd,'meta');
end

switch gd.ftype
    case 1
        gd.x=ncread(fullfile(pathname,filename),'x');
        gd.y=ncread(fullfile(pathname,filename),'y');
        gd.x_resolution=mode(diff(gd.x));
        gd.y_resolution=mode(diff(gd.y));
        

        
        %try to get metadata (new files only)
        info=ncinfo(fullfile(pathname,filename));
        if ~isempty(info.Attributes)
            for i=1:length(info.Attributes)
                gd.meta.(info.Attributes(i).Name)=...
                    info.Attributes(i).Value;
            end
            set(gd.vmeta,'visible','on')
        else
            gd.meta=[];
        end
        
        
    case 2
        
        
        %need to parse metadata in a xml struct
        info = h5info(fullfile(pathname,filename),'/BAG_root/metadata');
        mdata = h5read(fullfile(pathname,filename),'/BAG_root/metadata');
        
        mstr=cat(2,mdata{:});
        if ~isempty(info.FillValue)
            idx=strfind(mstr,info.FillValue);
            mstr(idx)=[];
        end
        
        stream = java.io.StringBufferInputStream(mstr);
        factory = javaMethod('newInstance', ...
            'javax.xml.parsers.DocumentBuilderFactory');
        builder = factory.newDocumentBuilder;
        doc = builder.parse(stream);
        
        %collect some of the metadata..could be expanded later
        fields={'resolution';...
            'cornerPoints';...
            'projection';...
            'zone';...
            'ellipsoid';...
            'datum'};
        
        vals=cell(size(fields,1),1);
        for i=1:length(fields)
            list=doc.getElementsByTagName(fields{i});
            len = list.getLength;
            vals{i} = cell(1, len);
            for j=1:len
                vals{i}(j) = list.item(j-1).getTextContent;
            end
        end
        
        %extract the corner points
        fmt='%f,%f %f,%f';
        cp=cell2mat(textscan(char(vals{2}),fmt));
        grid_extents=[cp(1) cp(3) cp(2) cp(4)];
        
        gd.y_resolution=str2double(vals{1}(1));
        gd.x_resolution=str2double(vals{1}(2));
        
        %generate x and y vals and read dataset
        gd.x=grid_extents(1):gd.x_resolution:grid_extents(2);
        gd.y=(grid_extents(3):gd.y_resolution:grid_extents(4))';
        
        gd.meta.pathname=pathname;
        gd.meta.filename=filename;
        gd.meta.projection=vals{3}{1};
        gd.meta.zone=vals{4}{1};
        gd.meta.horiz_datum=vals{5}{1};
        gd.meta.vert_datum=cat(2,vals{6}{:});
        gd.meta.ptype='cartesian';%need an example to try spherical
        gd.meta.horiz_units='m'; 
        gd.meta.vert_units='m'; %by the file format specification
        set(gd.vmeta,'visible','on')
end

%make sure no profiles are left
if gd.nump>0
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


fun=@(x)([min(x) max(x)]);
gd.xo=fun(gd.x);
gd.yo=fun(gd.y);
gd.xlims=gd.xo;
gd.ylims=gd.yo;

if gd.x_resolution<1
    sigdig=length(num2str(floor(1/gd.x_resolution)));
    gd.fmt=['%0.',sprintf('%0.0f',sigdig),'f',''];
else
    gd.fmt='%0.0f';
end

%remove extents
if isfield(gd,'xf')
    gd=rmfield(gd,{'xf';'yf';'zf'});
end
%remove clims
if isfield(gd,'clims')
    gd=rmfield(gd,'clims');
end


gd.guipath=pathname;
gd.filename=filename;
guidata(hf,gd);

optimize_view(hf);

hillshade_bathy(hf);
plot_overview(hf);

set(gd.ax1,'visible','on')
set(gd.options,'visible','on')
if gd.tools==1
    set(gd.toolbar,'visible','on')
    set(gd.panel1,'visible','on')
end
set(gd.loadp,'visible','on')
set(gd.mexport,'visible','on')

