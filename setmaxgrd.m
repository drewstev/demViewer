function setmaxgrd(hf,evnt) %#ok

gd=guidata(hf);
answer = inputdlg('Pixels to render',...
    'Set Display Resolution',1,{sprintf('%0.0f',gd.maxgrd)});

if ~isempty(answer)
    gd.maxgrd=floor(str2double(answer));
    if isfield(gd,'filename')
        
        
        %     gd=rmfield(gd,{'xf';'yf';'zf';'hs'});
        guidata(hf,gd)
        optimize_view(hf);
        
        gd=guidata(hf);
        set(gd.ph,'xdata',gd.xs(1,:),...
            'ydata',gd.ys(:,1),...
            'zdata',gd.zs,...
            'cdata',gd.hs);
        set(gd.ax1,'xlim',gd.xlims,'ylim',gd.ylims);
        
        set(gd.str,'string',['Displaying ',gd.filename, '  Resolution = ',...
            sprintf(gd.fmt,gd.res),' ',gd.meta.horiz_units],...
            'foregroundcolor','k')
        gd.jObj.stop
    else
        guidata(hf,gd);
        return
    end
else
    return
end


