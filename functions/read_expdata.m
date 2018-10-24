function [c d]=read_expdata(file)

[a b]=textread(file,'%s %s');
c=zeros(length(a)-1,1);
d=zeros(length(a)-1,1);
for I=1:length(a)-1
    c(I)=str2double(a{I+1});
    d(I)=str2double(b{I+1});
end;

end

    