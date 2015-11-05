function plot_profile(hf,evnt) %#ok

gd=guidata(hf);
gd.val=get(gd.selectprofile,'val');

figure
plot(gd.pdata(gd.val).dist,gd.pdata(gd.val).zi,'k-')
title(sprintf('Profile: %0.0f',gd.pdata(gd.val).pnum),...
    'fontweight','b','fontang','it')

switch gd.meta.ptype
    case 'spherical'
        xlabel('\bf\itDistance (m)') %always meters if spherical
    case 'cartesian'
         xlabel(['\bf\itDistance (',gd.meta.horiz_units,')'])
end

ylabel(['\bf\itElevation (',gd.meta.vert_units,')'])