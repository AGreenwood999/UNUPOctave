function [xpos, ypos] = get_position_on_ax_by_percent(percent_x, percent_y) 
% Function takes the percentage of the axis where you want the position
% and gives the x and y position that correspond to that percent.
% EXAMPLE:
% I want to get the x position and y position that are 90% of the x axis and 10% of the y axis
% And the xaxis spans from 0 to 1 and the yaxis spans from 0 to 1 then:
%{
[xpos, ypos] = get_position_on_ax_by_percent(90, 10);
%}
% xpos = 0.9 and ypos = 0.1

    x_coeff = polyfit([0, 100], xlim, 1);
    y_coeff = polyfit([0, 100], ylim, 1);

    xpos = x_coeff(1) * percent_x + x_coeff(2);
    ypos = y_coeff(1) * percent_y + y_coeff(2);
end
