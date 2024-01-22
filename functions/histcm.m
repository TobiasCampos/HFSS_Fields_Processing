function varargout = histcm(data,varargin)

a = reshape (data,[numel(data),1]);
a(a==0) = [];

if nargin == 2
    if size(varargin{1}) == [1 1] % if entry is a number
        edges = linspace(0,max(data,[],'all'),varargin{1});
    else
        edges = varargin{1};  % if entry is an array
    end

    [N,edges] = histcounts(a,edges);

elseif nargin == 1
    [N,edges] = histcounts(a);
end

figure
b = bar(edges(1:end-1),N,'BarWidth',1,'FaceColor','flat');
b.EdgeColor = 'none';
xline(mean(nonzeros(data),'all'),'Color',adjust_color([0 0 0]),'LineWidth',1.5)
set(gcf, 'Color','#212121');    % Plot Color
set(gca, 'Color','#212121');    % Axis Color

cm = turbo(size(b.CData,1));
for c = 1:size(b.CData,1)
    b.CData(c,:) = cm(c,:);
end

if nargout == 1
    varargout{1} = b;
end
if nargout == 3
    varargout{1} = edges(1:end-1);
    varargout{2} = N;
    varargout{3} = b;
end

end