function net = v1c_analyze(net)
% compute parametric representations of v1c

v1s_info=net.structure.layers{2};
v1c_info=net.structure.layers{3};

v1s=net.content.layers{2};
v1c=net.content.layers{3};

v1s_params=v1s.unitProperties.params;

v1s_num_nodes=v1s_info.width^2;
v1c_num_nodes=v1c_info.width^2;

[x0 y0 amp sigmax sigmay theta freq phi] = getParams(net);
x0=reshape(x0,v1s_info.numUnits,v1s_num_nodes);
y0=reshape(y0,v1s_info.numUnits,v1s_num_nodes);
amp=reshape(amp,v1s_info.numUnits,v1s_num_nodes);
sigmax=reshape(sigmax,v1s_info.numUnits,v1s_num_nodes);
sigmay=reshape(sigmay,v1s_info.numUnits,v1s_num_nodes);
theta=reshape(theta,v1s_info.numUnits,v1s_num_nodes);
freq=reshape(freq,v1s_info.numUnits,v1s_num_nodes);

params=zeros(6,v1c_info.numUnits,v1c_num_nodes);
for node=1:v1c_num_nodes
    pos=v1c.nodeProperties.cover(node,:);
    cx=pos(1); cy=pos(2);
    for unit=1:v1c_info.numUnits
        [mx my sx sy th fr]=v1c_repr(node,unit);
        params(:,unit,node)=[cx+mx-1 cy+my-1 sx sy th fr]; 
    end;
end;
net.content.layers{3}.unitProperties.params=params;


    function [mx my sx sy th fr]=v1c_repr(v1c_node,v1c_unit)
        v1s_node=v1c_node;
        weights=v1c.weights(:,1,v1c_unit,v1c_node);
%         weights=weights.*amp(:,v1s_node);
%         weights=softmax(weights);
        weights=weights/sum(weights);
        [~,id]=max(weights);
        th=orientationmean(theta(:,v1s_node),weights);

        mx=sum(x0(:,v1s_node).*weights);        
        my=sum(y0(:,v1s_node).*weights);
%         mx=0; my=0; C=0;
%         for v1s_unit=1:v1s_info.numUnits
%             if abs(orientationDiff(th,theta(v1s_unit,v1s_node)))<pi/8
%                 mx=mx+x0(v1s_unit,v1s_node); my=my+y0(v1s_unit,v1s_node); C=C+1;
%             end;
%         end;
%         mx=mx/C; my=my/C;

        s=sum(((x0(:,v1s_node)-mx).^2+(y0(:,v1s_node)-my).^2).*weights);
        sx=sum(sigmax(:,v1s_node).^2.*weights);
        sy=sum(sigmay(:,v1s_node).^2.*weights);
        sx=sqrt(s+sx);
        sy=sqrt(s+sy);

%         s=0; sx=0; sy=0;
%         for v1s_unit=1:v1s_info.numUnits
%             if abs(orientationDiff(th,theta(v1s_unit,v1s_node)))<pi/8
%                 s=s+(x0(v1s_unit,v1s_node)-mx)^2+(y0(v1s_unit,v1s_node)-my)^2;
%                 sx=sx+sigmax(v1s_unit,v1s_node)^2; sy=sy+sigmay(v1s_unit,v1s_node)^2;
%             end;
%         end;
%         sx=sqrt((s+sx)/C); sy=sqrt((s+sy)/C);

%         fr=1./(sum(1./freq(:,v1s_node).*weights));
%         fr=sum(freq(:,v1s_node).*weights);
        fr=freq(id,v1s_node);
    
    end

end


