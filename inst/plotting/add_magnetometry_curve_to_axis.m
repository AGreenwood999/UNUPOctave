function add_magnetometry_curve_to_axis(ax, data, fig_opts, ax_opts, plot_opts)
    fig = figure(fig_opts{:});
    ax = axes(ax_opts{:});
    plot(ax, data.G, data.emu_g, plot_opts{:})
end
