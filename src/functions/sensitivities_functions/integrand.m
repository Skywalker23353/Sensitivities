function I = integrand(p,x,x_mean,x_rms)
    a = x_mean *( ( (x_mean * (1-x_mean) )/(x_rms^2)) - 1);
    b = (1 - x_mean) *( ( (x_mean * (1-x_mean) )/(x_rms^2)) - 1);
    I = ppval(p,x).*betapdf(x,a,b);
end