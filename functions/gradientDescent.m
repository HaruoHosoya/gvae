function [params_opt,func_opt]=gradientDescent(obj,params0,options)

alpha0=1e-1;

alpha=alpha0;
params=params0;
[func,grad]=obj(params);

halt=false;
for T=1:options.maxIter
%     alpha=alpha0;
    while(true)
        params1=params-alpha*grad;
        if ~isempty(options.normalizer)
            params1=options.normalizer(params1);
        end;
        [func1,grad1]=obj(params1);
        if ~isinf(func1) && func1<func params=params1; grad=grad1; func=func1; break; end;
        alpha=alpha/2;
        if alpha<alpha0*1e-10 halt=true; break; end;
    end;
    if halt break; end;
    if ~isempty(options.normalizer)
        params1=options.normalizer(params1);
    end;

    fprintf('step #%d, objective=%1.5f, alpha=%1.3g)\n',T,func,alpha);
    
end;

params_opt=params;
func_opt=func;

end
                  