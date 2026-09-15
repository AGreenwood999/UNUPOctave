% add_standards_curve_to_axis  Plot the standards curve (points + fitted line).
%
%   [H_SCATTER, H_LINE, H_LEG] = add_standards_curve_to_axis(AX, DATA,
%   SCATTER_OPTS, LINE_OPTS) plots the raw standard-well (concentration,
%   absorbance) points from DATA.standards.X/.Y, overlays the fitted line
%   from DATA.standards.params (see get_standards.m), and returns a dummy
%   handle for legend display.
%
%   SCATTER_OPTS/LINE_OPTS are cell arrays of Name/Value plot option pairs,
%   passed straight through to the underlying plot() calls.
%
%   Returns:
%     H_SCATTER - handle to the raw standard-point scatter
%     H_LINE    - handle to the fitted calibration line
%     H_LEG     - handle to a dummy off-screen plot, styled with both
%                 SCATTER_OPTS and LINE_OPTS, purely so a legend entry can
%                 show a combined "circle with a line through it" marker
function [h_scatter, h_line, h_leg] = add_standards_curve_to_axis(ax, data, scatter_opts, line_opts)
    h_scatter = plot(ax, data.standards.X, data.standards.Y, "LineStyle", "none", "marker", "o", scatter_opts{:});
    h_line = plot(ax, data.standards.X, polyval(data.standards.params, data.standards.X), line_opts{:});

    % this makes a dummy plot that allows the legend to display a special marker that is a circle with 
    % a line through it. It may not be for everyone, but you don't have to use it
    h_leg = plot(ax, NaN, NaN, 'o-', scatter_opts{:}, line_opts{:});
end
