function net=strip_resp(net)

for I=1:length(net.structure.layers)
    if isfield(net.content.layers{I}.unitProperties,'resp')
        net.content.layers{I}.unitProperties.resp=[];
    end;
end;

end
