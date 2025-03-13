% Function takes the current limits of x and y axis, and the percent of x and y lines 
% and gives the x and y position that correspond to that percent.
% EXAMPLE:
% I want to get the x position and y position that are 90% of the x axis and 10% of the y axis
%{
[xpos, ypos] = get_position_on_ax_by_percent(xlim, ylim, 90, 10);
%}
function [xpos, ypos] = get_position_on_ax_by_percent(xlims, ylims, percent_x, percent_y) 
    x_coeff = polyfit([0, 100], xlims, 1);
    y_coeff = polyfit([0, 100], ylims, 1);

    xpos = x_coeff(1) * percent_x + x_coeff(2);
    ypos = y_coeff(1) * percent_y + y_coeff(2);
end
