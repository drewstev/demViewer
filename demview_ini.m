function ini=demview_ini(fname)

fmt='%s';
fid=fopen(fname);
paths=textscan(fid,fmt,'delimiter','');
paths=paths{1};

ini=repmat(struct('filename',[],...
    'pathname',[]),length(paths),1);
nrec=1;
for i =1:length(paths)
    if exist(paths{i},'file');
       [rpath,rfile,rext]=fileparts(paths{i});
       if isempty(rpath)
           rpath=pwd;
       end
       ini(nrec).filename=[rfile,rext];
       ini(nrec).pathname=[rpath,filesep];
       nrec=nrec+1;

    end
end
ini=ini(1:nrec-1);

if nrec-1==0
    ini=[];
end
fclose(fid);