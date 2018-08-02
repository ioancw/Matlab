%how to manually calculate pinverse from the svd.
A = [ 1 0 0 0 2;0 0 3 0 0;0 0 0 0 0;0 4 0 0 0]
A_pinv = pinv(A)
[U, S, V] = svd(A);
[U, S, V] = svd(A,'econ');
A_reconstituted = U*S*V';
S_1 = S.^-1; %invert elements
S_1(~isfinite(S_1))=0; %set those infinity to zero
A_pinv_2 = V*S_1*U'

