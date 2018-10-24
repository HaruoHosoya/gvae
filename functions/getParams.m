function [x0 y0 amp sigmax sigmay theta freq phi] = getParams(net)
    
num=net.structure.layers{2}.width^2 * net.structure.layers{2}.numUnits;
params=net.content.layers{2}.unitProperties.params;
q=reshape(permute(params,[2,3,1]),num,8);
x0=q(:,1);
y0=q(:,2);
amp=q(:,3);
sigmax=q(:,4);
sigmay=q(:,5);
theta=q(:,6);
freq=q(:,7);
phi=q(:,8);

end
