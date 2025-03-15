function [m, b, R2, yfit] = linear_fit(x, y)
% Takes x and y data points, fits a curve to them and returns 
% the two parameters (slope and intercept),coefficient of determination
% and the y values for the fit (to make plotting easier)
% x should be a 1, 5 vector 
% y should be a x, 5 matrix

    filled_x = repmat(x, size(y, 1), 1);
    coeff = polyfit(filled_x(:), y(:), 1);
    m = coeff(1);
    b = coeff(2);

    R2 = 1 - sum( ( (m * filled_x(:) + b) - y(:) ).^2 ) / sum( ( mean( y(:) ) - y(:) ).^2 );

    yfit = m * x + b;
end
