% MDIM_SORT_EIG Multidimensional eigenvalue sort
%
% Usage
%    [V, D] = mdim_sort_eig(V, D);
%
% Input
%    V: An array of eigenvectors of size sig_sz-by-prod(sig_sz).
%    D: A matrix of eigenvalues of size prod(sig_sz)-by-prod(sig_sz). This
%       and V and typically obtained from the mdim_eig function.
%
% Output
%    V: The array of eigenvectors, sorted according to the corresponding
%       eigenvalues (in decreasing order) along its last dimension.
%    D: The matrix of sorted eigenvalues.

function [V, D] = mdim_sort_eig(V, D)
    d = ndims(V)-1;

    sig_sz = size(V);
    sig_sz = sig_sz(1:d);

    [~, I] = sort(diag(D), 'descend');

    idx.type = '()';
    idx.subs = [repmat({':'}, [1 d]) I];

    V = subsref(V, idx);
    D = D(I,I);
end
