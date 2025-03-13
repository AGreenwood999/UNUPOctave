% Takes x and y data points, fits a curve to them and returns 
% the two parameters (slope and intercept),coefficient of determination
% and the y values for the fit (to make plotting easier)
% It is advisable to flatten your data, I'll do it for you to make things
% easy, and it may not land how you would like  
function [m, b, R2, yfit] = linear_fit(x, y)
    coeff = polyfit(x(:), y(:), 1);
    m = coeff(1);
    b = coeff(2);

    yfit = m * x(:) + b;
    R2 = 1 - sum( (yfit(:) - y(:)).^2 ) / sum( (mean(y(:)) - y(:)).^2 );
end
