% sample_colormap_uniform  Sample N visually-spread-out colors from a colormap.
%
%   CMAP = sample_colormap_uniform(N) picks N rows, evenly spaced by index,
%   out of the current figure's colormap.
%
%   CMAP = sample_colormap_uniform(BASE_CMAP, N) does the same, but from
%   BASE_CMAP (anything accepted by colormap(), e.g. a name like "jet" or
%   an existing Mx3 colormap matrix) instead of the current colormap.
%
%   Errors if N is larger than the number of visually-distinct rows
%   available after rounding to unique indices -- i.e. if the base
%   colormap doesn't have enough rows to give every sample a distinct
%   color at this resolution.
function cmap = sample_colormap_uniform(varargin)
    if nargin == 1 
        cmap = colormap();
        n = varargin{1};
    elseif nargin == 2
        cmap = colormap(varargin{1});
        n = varargin{2};
    end

    % Evenly spaced indices into the colormap; rounding + unique() can
    % collapse duplicates if n is large relative to the colormap size.
    idx = unique(round(linspace(1, size(cmap, 1), n)));

    if length(idx) < n
        error(["sample_colormap_uniform: requested ", num2str(n), " distinct colors but the base colormap (", ...
               num2str(size(cmap, 1)), " rows) only yields ", num2str(length(idx)), ...
               " unique samples at this resolution. Use a colormap with more rows, or reduce the number of samples."]);
    end

    cmap = cmap(idx, :);
end


% TODO: Tests?
