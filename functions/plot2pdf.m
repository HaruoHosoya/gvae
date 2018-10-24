function plot2pdf(h,fname,varargin)
% plot2pdf(h,fname)
%  h: figure, fname: file name
parser=inputParser;
parser.addParamValue('size',[],@isnumeric);
parser.parse(varargin{:});
options=parser.Results;

if isempty(options.size)
    res=get(0,'screenpixelsperinch');
    pos=get(h,'Position');
    sx=pos(3)/res; sy=pos(4)/res;
else
    sx=options.size(1);
    sy=options.size(2);
end;

set(h,'PaperPosition',[0 0 sx sy]);
set(h,'PaperSize',[sx sy]);
saveas(h,fname,'pdf')

end
