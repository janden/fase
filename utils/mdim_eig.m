% MDIM_EIG Multidimensional eigendecomposition
%
% Usage
%    [V, D] = mdim_eig(A);
%
% Input
%    A: An array of size sig_sz-by-sig_sz, where sig_sz is a size containing
%       d dimensions. The array represents a matrix with d indices for its
%       rows and columns.
%
% Output
%    V: An array of eigenvectors of size sig_sz-by-prod(sig_sz).
%    D: A matrix of size prod(sig_sz)-by-prod(sig_sz) containing the
%       corresponding eigenvalues.

function [V, D] = mdim_eig(A)
    if mod(ndims(A), 2) ~= 0
        error('Matrix must have an even number of dimensions');
    end

    d = ndims(A)/2;

    sig_sz = size(A);
    sig_sz = sig_sz(1:d);

    sig_len = prod(sig_sz);

    A = reshape(A, sig_len*ones(1, 2));

    [V, D] = eig(A);

    V = reshape(V, [sig_sz sig_len]);
end
