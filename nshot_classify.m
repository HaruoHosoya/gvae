function [sucrate,sucidx]=nshot_classify(z,z_pr,clamap,gallery,probe,varargin)

pr=inputParser;
pr.addParamValue('dist','cosine',@isstr);
pr.addParamValue('combine',false,@islogical);

pr.parse(varargin{:});
options=pr.Results;

nsplit=length(gallery);
sucrate=zeros(nsplit,1);

for I=1:nsplit
    if options.combine
        [z_comb,z_pr_comb,clamap_comb]=combine_gallery(z,z_pr,gallery{I},clamap);
        dst=dist(z(:,probe{I}),z_pr(:,probe{I}),z_comb,z_pr_comb,options.dist);
        [~,J]=min(dst,[],2);
        sucidx{I}=find(clamap(probe{I})==clamap_comb(J));
        nsuc=length(sucidx{I});
        ntot=length(J);
    else
        dst=dist(z(:,probe{I}),z_pr(:,probe{I}),z(:,gallery{I}),z_pr(:,gallery{I}),options.dist);
        [~,J]=min(dst,[],2);
        sucidx{I}=find(clamap(probe{I})==clamap(gallery{I}(J)));
        nsuc=length(sucidx{I});
        ntot=length(J);
    end
    sucrate(I)=nsuc/ntot;
end

end

function dst=dist(z1,z1_pr,z2,z2_pr,ty)

[~,nimg1]=size(z1);
[~,nimg2]=size(z2);

switch(ty)
    case 'cosine'
        z1=z1./sqrt(sum(z1.^2,1));
        z2=z2./sqrt(sum(z2.^2,1));
        dst=-z1'*z2;
    case 'euclid'
        zz=z1'*z2;
        dst=repmat(sum(z1.^2,1)',1,nimg2)+repmat(sum(z2.^2,1),nimg1,1)-2*zz;
    case 'xeuclid'  % works for MLVAE
        zz=z1'*z2;
        dst=repmat(sum(z1.^2,1)',1,nimg2)+repmat(sum(z2.^2,1),nimg1,1)-2*zz;
        dst=dst+repmat(sum(1./z1_pr,1)',1,nimg2)+repmat(sum(1./z2_pr,1),nimg1,1);
end

end

function [z_comb,z_pr_comb,clamap_comb]=combine_gallery(z,z_pr,gallery,clamap)
% works for MLVAE

zdim=size(z,1);
cla=unique(clamap);
ncla=length(cla);
z_comb=zeros(zdim,ncla);
z_pr_comb=zeros(zdim,ncla);
clamap_comb=zeros(ncla,1);

for I=1:ncla
    g=gallery(clamap(gallery)==cla(I));
    z_pr_comb(:,I)=sum(z_pr(:,g),2);
    z_comb(:,I)=sum(z(:,g).*z_pr(:,g),2)./z_pr_comb(:,I);
    clamap_comb(I)=cla(I);
end

end
