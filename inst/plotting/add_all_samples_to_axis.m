% add_all_samples_to_axis  Plot every sample in DATA onto an axis, color-coded.
%
%   [HS, LEG, LABELS] = add_all_samples_to_axis(AX, DATA, SCATTER_OPTS,
%   LINE_OPTS) loops over every field of DATA.samples (see get_samples.m),
%   assigning each one an x-position spread evenly across the current
%   x-limits of AX and a distinct color from a uniformly-sampled colormap
%   (see sample_colormap_uniform.m), then delegates the actual per-sample
%   plotting to add_sample_to_axis.
%
%   SCATTER_OPTS/LINE_OPTS are cell arrays of Name/Value plot option pairs
%   passed through to the underlying scatter/mean-line plots for every
%   sample (on top of the per-sample color).
%
%   NOTE: this reads the axis's *current* xlim to lay out sample
%   x-positions, so it currently must be called after the standards curve
%   (or something else establishing the desired x-range) has already been
%   plotted onto AX -- see TODO above.
%
%   Returns:
%     HS     - struct array of handles, HS(i).scatter / HS(i).line per sample
%     LEG    - handle array of legend-only dummy plots, one per sample
%              (see add_sample_to_axis.m for why this exists)
%     LABELS - cell array of each sample's original (unsanitized) name,
%              in the same order as LEG -- pass directly to legend(),
%              e.g. legend(leg, labels), to show "Sample A" rather than
%              the sanitized struct field name "SampleA".
function [hs, leg, labels] = add_all_samples_to_axis(ax, data, scatter_opts, line_opts)
    names = fieldnames(data.samples);

    % One evenly-spaced color per sample, sampled from the current colormap.
    cmap = sample_colormap_uniform(length(names));

    % Spread sample x-positions across 5%-95% of the current x-range so
    % they don't sit flush against the axis edges.
    xl = xlim;
    xs = linspace((xl(2) - xl(1)) * 0.05 + xl(1), (xl(2) - xl(1)) * 0.95 + xl(1), length(names));
    for i = 1:length(names)
        [hs(i).scatter, hs(i).line, leg(i)] = add_sample_to_axis(
            ax,...
            xs(i),...
            data.samples.(names{i}),...
            {"color", cmap(i, :), scatter_opts{:}},...
            {"color", cmap(i, :), line_opts{:}}...
        );
        % Pull the original, unsanitized label back out of the sample
        % struct so callers get something display-worthy for a legend
        % without having to know about the field-name sanitizing at all.
        labels{i} = data.samples.(names{i}).name;
    end
end
