function VisFoto(n,X)

figure
for i = 1:n
    subplot(floor(n/10)+1,10, i), imagesc(X(:,:,i)), colormap gray(256);

end