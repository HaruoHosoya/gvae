function nets=load_nets(dir_name,varargin)

pr=inputParser;
pr.addParamValue('last',false,@islogical);
pr.addParamValue('skip',1,@isnumeric);
pr.parse(varargin{:});
options=pr.Results;


d=dir([dir_name '/*.mat']);
if options.last
    II=length(d);
else
    II=1:options.skip:length(d);
end

nets={}; 
J=1;
for I=II
    load([d(I).folder '/' d(I).name]);
    nets{J}=net_tmp; J=J+1;
end

end
