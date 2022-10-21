function estrData = EstrData(n,X)

MiniData = double(X(:,:,1:n));

% for i = 1:n
%     subplot(floor(n/10)+1,10, i), imagesc(MiniData(:,:,i)), colormap gray(256);
% 
% end

estrData = MiniData;


