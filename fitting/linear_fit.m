function [m, b, R2, yfit] = linear_fit(x, y)
    coeff = polyfit(x(:), y(:), 1);
    m = coeff(1);
    b = coeff(2);

    yfit = m * x(:) + b;
    R2 = 1 - sum( (yfit(:) - y(:)).^2 ) / sum( (mean(y(:)) - y(:)).^2 );
end
