A = imread('/Users/ReallyBigIoan/Pictures/HD(990)/Aurelia-35283-Edit.jpg');
X = double(rgb2gray(A));
nx = size(X,1); ny = size(X,2);
[U, S, V] = svd(X);

figure, subplot(2,2,1)
imagesc(X), axis off, colormap gray
title('Original')

plotind = 2;
for r = [5 20 100]
    Xapprox = U(:,1:r)* S(1:r,1:r)*V(:,1:r)';
    subplot(2,2,plotind), plotind = plotind +1;
    imagesc(Xapprox), axis off
    title(['r=',num2str(r,'%d'),',',num2str(100*r*(nx+ny)/(nx*ny),'%2.2f'),'% storage']);
end
set(gcf, 'Position',[100 100 550 400])