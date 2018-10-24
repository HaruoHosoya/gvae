function [ basis width num ] = getV1Bases(net)

weights=net.content.layers{2}.weights(1,:,:,:);
[~,v0nodes,v1units,v1nodes] = size(weights);
width=sqrt(v0nodes);
num=v1units*v1nodes;
basis=reshape(weights,width,width,num);

end

