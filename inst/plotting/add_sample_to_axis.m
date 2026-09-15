% add_sample_to_axis  Plot one sample's replicate absorbance values plus their mean.
%
%   [H_SCATTER, H_LINE, H_LEG] = add_sample_to_axis(AX, X, SAMPLE,
%   SCATTER_OPTS, LINE_OPTS) plots every replicate absorbance reading in
%   SAMPLE.absorbance as a column of points at x-position X, draws a
%   horizontal line at their mean, and returns a dummy handle for legend
%   display.
%
%   SCATTER_OPTS/LINE_OPTS are cell arrays of Name/Value plot option pairs
%   (e.g. {"color", [1 0 0]}), passed straight through to the underlying
%   plot() / yline() calls -- any values here override the "LineStyle"/
%   "marker" defaults set below since they're spread in afterwards.
%
%   Returns:
%     H_SCATTER - handle to the replicate-points scatter
%     H_LINE    - handle to the mean yline
%     H_LEG     - handle to a dummy off-screen plot, styled with both
%                 SCATTER_OPTS and LINE_OPTS, purely so a legend entry can
%                 show a combined "circle with a line through it" marker
function [h_scatter, h_line, h_leg] = add_sample_to_axis(ax, x, sample, scatter_opts, line_opts)
    h_scatter = plot(ax, repmat(x, [1, length(sample.absorbance)]), sample.absorbance, "LineStyle", "none", "marker", "o", scatter_opts{:});
    h_line = yline(ax, mean(sample.absorbance), line_opts{:});

    % this makes a dummy plot that allows the legend to display a special marker that is a circle with
    % a line through it. It may not be for everyone, but you don't have to use it
    h_leg = plot(ax, NaN, NaN, 'o-', scatter_opts{:}, line_opts{:});
end
