function net=calc_coverage(net)

nlayers=length(net.structure.layers);

v0_info=net.structure.layers{1};

u=1;
cover=zeros(v0_info.width^2,4);
for y=1:v0_info.width
    for x=1:v0_info.width
        cover(u,:)=[x y 1 1];
        u=u+1;
    end;
end;

net.content.layers{1}.nodeProperties.cover=cover;
net.content.layers{1}.nodeProperties.relcover=cover;
        
for l=2:nlayers
    curr=net.structure.layers{l};
    lower=net.structure.layers{l-1};
    if curr.width==1
        relcover=[1 1 lower.patchWidth lower.patchWidth];
        cover=[1 1 v0_info.width v0_info.width];
    else
        u=1;
        relcover=[];
        cover=[];
        lowercover=net.content.layers{l-1}.nodeProperties.cover;
        step=(lower.width-lower.patchWidth)/(curr.width-1);
        for y=1:curr.width
            for x=1:curr.width
                lowerx=round(step*(x-1)+1);
                lowery=round(step*(y-1)+1);
                relcover=[relcover; lowerx lowery lower.patchWidth lower.patchWidth];
                loweru=lowerx+(lowery-1)*lower.width;
                x1=lowercover(loweru,1); y1=lowercover(loweru,2);
                loweru=(lowerx+lower.patchWidth-1)+((lowery+lower.patchWidth-1)-1)*lower.width;
                w1=lowercover(loweru,1)+lowercover(loweru,3)-x1; h1=lowercover(loweru,2)+lowercover(loweru,4)-y1;
                cover=[cover; x1 y1 w1 h1];
                u=u+1;
            end;
        end;
    end;
    net.content.layers{l}.nodeProperties.relcover=relcover;
    net.content.layers{l}.nodeProperties.cover=cover;
        
end;

end

                