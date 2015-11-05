function [B lims map] = real2rgb(A, cmap, lims)
%REAL2RGB  Converts a real-valued matrix into a truecolor image
%
% Examples:
%   B = real2rgb(A, cmap);
%   B = real2rgb(A, cmap, lims);
%   [B lims map] = real2rgb(...);
%
% This function converts a real-valued matrix into a truecolor image (i.e.
% double array with values between 0 and 1) using the colormap specified
% (either user-defined or the name of a colormap function). The output
% image is suitable for display using IMAGE or IMSHOW, exporting using
% IMWRITE, texture mapping a surface etc.
%
% Colormaps specified by name, e.g. 'hot', can be reversed ('-hot'), made
% to convert linearly to grayscale when printed on a black & white printer
% ('hot*'), or both ('-hot*').
%
% Value limits and a colormap table can be output, for use generating the
% correct colorbar, e.g.:
%   [B lims map] = real2rgb(peaks(256), '-hot*');
%   hIm = imshow(B);
%   set(gcf, 'Colormap', map);
%   set(gca, 'CLim', lims);
%   set(hIm, 'CDataMapping', 'scaled');
%   colorbar;
%
% IN:
%   A - MxN real matrix.
%   cmap - JxK user-defined colormap, or a string indicating the name
%          of the colormap to be used. K = 3 or 4. If K == 4 then
%          cmap(1:end-1,4) contains the relative widths of the bins between
%          colors. If cmap is a colormap function name then the prefix '-'
%          indicates that the colormap is to be reversed, while the suffix
%          '*' indicates that the colormap bins are to be rescaled so that
%          each bin produces the same change in gray level, such that the
%          colormap converts linearly to grayscale when printed in black
%          and white.
%   lims - 1x2 array of saturation limits to be used on A. Default:
%          [min(A(:)) max(A(:))].
%
% OUT:
%   B - MxNx3 truecolor image.
%   lims - 1x2 array of saturation limits used on A. Same as input lims, if
%          given.
%   map - 256x3 colormap similar to that used to generate B.

% $Id: real2rgb.m,v 1.10 2009/04/13 12:16:22 ojw Exp $
% Copyright: Oliver Woodford, 2009

% Don't do much if A is wrong size
[y x c] = size(A);
if c > 1
    error('A can only have 2 dimensions');
end
if y*x*c == 0
    % Create an empty array with the correct dimensions
    B = zeros(y, x, (c~=0)*3);
    return
end

% Generate the colormap
if ischar(cmap)
    % If map starts with a '-' sign, invert the colormap
    reverseMap = cmap(1) == '-';
    % If the map ends with a '*', attempt to make map convert linearly to
    % grayscale
    grayMap = cmap(end) == '*';
    % Extract the map name
    cmap = lower(cmap(reverseMap+1:end-grayMap));
    % Load the map
    try
        % Check for a concise table first
        map = feval(cmap, Inf);
    catch
        map = [];
    end
    if invalid_map(map)
        try
            % Just load a large table
            map = feval(cmap, 1024);
        catch
            error('Colormap ''%s'' not found', cmap);
        end
        if invalid_map(map)
            error('Invalid colormap');
        end
    end
    if reverseMap
        % Reverse the map
        map = map(end:-1:1,:);
        if size(map, 2) == 4
            % Shift up the bin lengths
            map(1:end-1,4) = map(2:end,4);
        end
    end
    if grayMap && size(map, 1) > 2
        % Ensure the map converts linearly to grayscale
        map(1:end-1,4) = abs(diff(map(:,1:3) * [0.299; 0.587; 0.114]));
    end
else
    % Table-based colormap given
    map = cmap;
end

% Only work with real doubles
B = reshape(double(real(A)), y*x, c);

% Compute limits and scaled values
maxInd = 1 + (size(map, 1) - 2) * (size(map, 2) ~= 4);
if nargin < 3
    lims = [];
end
[B lims] = rescale(B, lims, [0 maxInd]);

% Compute indices and offsets
if size(map, 2) == 4
    % Non-linear colormap
    bins = map(1:end-1,4);
    cbins = cumsum(bins);
    bins(bins==0) = 1;
    bins = cbins(end) ./ bins;
    cbins = [0; cbins(1:end-1) ./ cbins(end); 1+eps];
    [ind ind] = histc(B, cbins);
    B = (B - cbins(ind)) .* bins(ind);
    clear bins cbins
else
    % Linear colormap
    ind = min(floor(B), maxInd-1);
    B = B - ind;
    ind = ind + 1;
end

% Compute the output image
B = B(:,[1 1 1]);
B = map(ind,1:3) .* (1 - B) + map(ind+1,1:3) .* B;
B = min(max(B, 0), 1); % Rounding errors can make values slip outside bounds
B = reshape(B, y, x, 3);

if nargout > 2 && (size(map, 1) < 256 || size(map, 2) == 4)
    % Generate the colormap (for creating a colorbar with)
    map = reshape(real2rgb(1:256, map), 256, 3);
end
return

function notmap = invalid_map(map)
notmap = isempty(map) || ndims(map) ~= 2 || size(map, 1) < 1 || size(map, 2) < 3 || size(map, 2) > 4 || ~all(reshape(map(:,1:3) >= 0 & map(:,1:3) <= 1, [], 1));

function [B lims] = rescale(A, lims, out_lims)
%RESCALE  Linearly rescale values in an array
%
% Examples:
%   B = rescale(A)
%   B = rescale(A, lims)
%   B = rescale(A, lims, out_lims)
%   [B lims] = rescale(A)
%
% Linearly rescales values in an array, saturating values outside limits.
%
% IN:
%   A - Input array of any size and class.
%   lims - 1x2 array of saturation limits to be used on A. Default:
%          [min(A(:)) max(A(:))].
%   out_lims - 1x2 array of output limits the values in lims are to be
%              rescaled to. Default: [0 1].
%
% OUT:
%   B - size(A) double array.
%   lims - 1x2 array of saturation limits used on A. Equal to the input
%          lims, if given.

% $Id: rescale.m,v 1.2 2009/04/05 15:09:11 ojw Exp $
% Copyright: Oliver Woodford, 2009

if nargin < 3
    out_lims = [0 1];
end
if nargin < 2 || isempty(lims)
    M = isfinite(A);
    if ~any(reshape(M, numel(M), 1))
        % All NaNs, Infs or -Infs
        B = double(A > 0);
        lims = [0 1];
    else
        lims = [min(A(M)) max(A(M))];
        B = normalize(A, lims, out_lims);
    end
    clear M
else
    B = normalize(A, lims, out_lims);
    B = min(max(B, out_lims(1)), out_lims(2));
end
return

function B = normalize(A, lims, out_lims)
if lims(2) == lims(1) || out_lims(1) == out_lims(2)
    B = zeros(size(A));
else
    B = double(A);
    if lims(1)
        B = B - lims(1);
    end
    v = (out_lims(2) - out_lims(1)) / (lims(2) - lims(1));
    if v ~= 1
        B = B * v;
    end
end
if out_lims(1)
    B = B + out_lims(1);
end
return