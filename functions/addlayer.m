function net=addlayer(net,layerNum,name,width,numUnits,patchWidth)

    str=struct;
    str.name=name;
    str.width=width;
    str.numUnits=numUnits;
    str.patchWidth=patchWidth;
    net.structure.layers{layerNum}=str;

    if layerNum>1
    %     lowerWidth=net.structure.layers{layerNum-1}.width;
        lowerPatchWidth=net.structure.layers{layerNum-1}.patchWidth;
        lowerNumUnits=net.structure.layers{layerNum-1}.numUnits;
    end;
    
    cnt=struct;
    cnt.layerProperties=struct;
    cnt.layerProperties2=struct;
    cnt.nodeProperties=struct;
    cnt.nodeProperties2=struct;
    cnt.unitProperties=struct;
    cnt.unitProperties2=struct;
    cnt.unitProperties3=struct;    
    if layerNum>1
        cnt.weights=zeros(lowerNumUnits,lowerPatchWidth^2,numUnits,width^2);
    end;
    net.content.layers{layerNum}=cnt;

end