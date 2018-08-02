%J = dlmread('/Users/ioanwilliams/Downloads/matrix-small.csv');
J = dlmread('/Users/ioanwilliams/Downloads/USDSmallMatrix.csv');
[m,n] = size(J);
[rotation, eVals, eVecs,inverses] = eigen_decomposition(J'*J);

zeroTranspose = get_zero_transpose(eVals, eVecs);

weights = eye(n,n);
zero = zeroTranspose';
B = zeroTranspose * weights * zero;
[rotation_B, eVals_B, eVecs_B, inversesB] = eigen_decomposition(B);

b = zeros(size(J,1),1);
%b(85,1) = 1000000;
b(30,1) = 1000000;
rotatedRisk = rotation * J'* b;
risk_inverse = pinv(J, 1e-4) * b;

results = horzcat(rotatedRisk, risk_inverse);
%B etc.
weighted = rotation_B * zeroTranspose * weights;

C = weighted * rotatedRisk;
C_T = (C'*zeroTranspose)';

returnedRisk = rotatedRisk - C_T;

function [eigen_inv, inverse_lambdas2, evecs_S, inverses] = eigen_decomposition(A)
    [evecs, evals] = eig(A);
    %sort vecs and vals
    [evals_S,ind] = sort(diag(evals), 'descend');
    evecs_S = evecs(:,ind);
    %invert eigen values within tolerance
    inverse_lambdas2 = invertEigenValues2(evals_S);
    inverse_lambdas1 = invertEigenValues(evals_S);
    inverses = horzcat(evals_S,diag(inverse_lambdas2), diag(inverse_lambdas1));
    %eigen decomposition
    eigen_inv = evecs_S * inverse_lambdas2 * evecs_S';
end

function inverse_lambdas = invertEigenValues(lambdas)
    m = size(lambdas,1);
    inverse_lambdas = zeros(m,1);
    tol = 1e-4;
    for i = 1:m
        if (abs(lambdas(i)/lambdas(1))^0.5 >= tol)
            inverse_lambdas(i) = 1/lambdas(i);
        end
    end
    inverse_lambdas = diag(inverse_lambdas);
end

function inverse = invertEigenValues2(lambdas)
    tol = 1e-2;
    r2 = size(lambdas,1);
    lambdas(lambdas<tol) = 0;
    inverse = diag(ones(r2,1)./lambdas);
    inverse(~isfinite(inverse))=0;
end

function zeroTranspose = get_zero_transpose(eVals, eVecs)
    [m, n] = size(eVals);
    zeroTranspose = zeros(size(eVals));
    for i = 1:m
        for j = 1:n
            if eVals(i,i) == 0
                zeroTranspose(i,j)=eVecs(i,j);
            end
        end
    end
end

%[Evecs, Evals] = eig(JTxJ);
%[Evals_S,ind] = sort(diag(Evals), 'descend');
%Evecs_S = Evecs(:,ind);

%tol = 1e-4;
%two ways to do it, trim matrix, or just set to zero.
%r = sum( Evals_S > tol);
%s = diag(ones(r,1)./Evals_S(1:r));
% this is the equivalent of (X^T * X)^-1
%Rotation = Evecs_S(:,1:r)*s*Evecs_S(:,1:r)';
%multiply this by (X^T * b) (where b is the risk)
%results = horzcat(rotatedRisk, rotatedRisk2);
