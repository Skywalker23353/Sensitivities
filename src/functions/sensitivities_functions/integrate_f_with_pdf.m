function [q] = integrate_f_with_pdf(p,x_mean,x_rms,eps)
    if x_mean <= eps
        q = ppval(p,0);
    elseif x_mean > eps && x_mean < (1 - eps)
        [q, ~] = quadgk(@(x) integrand(p,x,x_mean,x_rms) ,0,1,"AbsTol",1e-6,"RelTol",0);
    elseif x_mean >= eps
        q = ppval(p,1);
    else
        fprintf("C_mean out of range : %e",x_mean);
    end
end
