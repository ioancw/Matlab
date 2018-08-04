%print out matrix using a heat map

J = csvread('/Users/ReallyBigIoan/Library/Mobile Documents/com~apple~CloudDocs/small_matrix_eur.csv');
indices = find(abs(J)<0.1);
J_ind = J;
J_ind(indices) = 0;
imagesc(J_ind,[-0.1,0.1]);
colormap ([0 0 1; 1 1 1; 1 0 0]);