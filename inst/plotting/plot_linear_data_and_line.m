function plot_linear_data_and_line(x, y, scatteropts, plotopts, textopts)
% Plot data to current figure (hold must already be on)
% scatteropts is "Property", "Value" pairs as a cell array passed to scatter plot
% plotopts  is "Property", "Value" pairs as a cell array passed to the line plot
% textopts  is "Property", "Value" pairs as a cell array passed to the function which shows equation params
%   Unfortuantely, a current limitation is if you specify a textopts, the furst two elements must be the percent of the axis where the text should be 
%   ie a textopts of {10, 10} would put the text at 10% of the x axis and 10% of the y axis
% EXAMPLE (put this into octave):
%{
x = [1, 2, 3, 4] + rand(1, 4)
y = [2, 3, 4, 5] + rand(1, 4)
plot_linear_data_and_line(x, y, {100, "DisplayName", "IM A SCATTER PLOT", '+'}, {"DisplayName", "IM A line PLOT"}, {50, 10, "FontSize", 20})
legend()
%}
    if ~exist("scatteropts", "var")
        scatteropts = {};
    end
    if ~exist("plotopts", "var")
        plotopts = {};
    end
    if ~exist("textopts", "var")
        textopts = {90, 10};
    else 
      isstring(textopts{1})
        if ischar(textopts{1}) || ischar(textopts{2}) 
          error("\
textopts variable must either be nothing, or the first two elements must be the \
scalar position of the text to be placed on the axis.\nFor example, you can do: \
{50, 10, \"FontSize\", 20}, or {} or nothing but {\"FontSize\", 20} will fail\
")
        end
    end

    [slope, inter, R2, yfit] = linear_fit(x, y);
    scatter(repmat(x, size(y, 1), 1), y, scatteropts{:});
    plot(x, yfit, plotopts{:});

    [xpos, ypos] = get_position_on_ax_by_percent(textopts{1}, textopts{2});

    text(xpos, ypos, sprintf("y=%.3fx+%.3f\nR^2=%.3f", slope, inter, R2), textopts{3:end});
end
