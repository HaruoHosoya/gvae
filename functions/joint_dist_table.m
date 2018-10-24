function joint_dist_table(r,xunits,yunits,varargin)

pr=inputParser;
pr.addParamValue('style','histogram',@isstr);
pr.parse(varargin{:});
options=pr.Results;

nx=length(xunits);
ny=length(yunits);

P=1;
for y=1:ny
    for x=1:nx
        subplot(ny,nx,P);P=P+1;
        switch(options.style)
            case 'histogram'
                cnt=hist3([r(:,xunits(x)) r(:,yunits(y))],{-10:0.5:10,-10:0.5:10});
                imagesc(log(cnt)');
                axis xy;axis square;set(gca,'xtick',[]);set(gca,'ytick',[]);
            case 'scatter'
                scatter(r(:,xunits(x)),r(:,yunits(y)));
                axis xy;axis square;set(gca,'xtick',[]);set(gca,'ytick',[]);
            case 'contour'
                cnt=hist3([r(:,xunits(x)) r(:,yunits(y))],{-10:0.5:10,-10:0.5:10});
                s=log(cnt)'; s(isinf(s))=0;
                contour(s,5);
                axis xy;axis square;set(gca,'xtick',[]);set(gca,'ytick',[]);
        end;                
        if y==ny xlabel(num2str(xunits(x))); end;
        if x==1 ylabel(num2str(yunits(y))); end;
    end;
end;

colormap(jet);

end