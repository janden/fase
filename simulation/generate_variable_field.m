% GENERATE_VARIABLE_FIELD Generate field by combining fixed sources
%
% Usage
%    [x, coeff] = generate_variable_field(sig_sz, n, psd_fun, coeff_fun, opt);
%
% Input
%    sig_sz: The desired size of the generated fields.
%    n: The number of fields to generate.
%    psd_fun: A cell array of r function handles defining power spectral
%       densities.
%    coeff_fun: A cell array of r function handles taking size as an input
%       and returning a randomly distributed array of that size. Each function
%       handle is used to generate the coefficients with which the fields of
%       the different power spectral distributions are to be combined. If a
%       single function handle is given, that distribution is used for all
%       fields (default {@randn}).
%    opt: An options structure. This is not used directly by the function, but
%       is passed on to generate_field.
%
% Output
%    x: An array of size sig_sz-by-n containing the generated fields.
%    coeff: An array of size r-by-n containing the coefficients used when
%       multiplying the fields prior to summation.
%
% Description
%    For each of the r function handles in psd_fun, this function generates
%    n fields with power spectral distribution psd_fun{l}. A set of n
%    coefficients are then generated using coeff_fun{l}, which are used to
%    multiply the generated fields. These are then summed across l to yield
%    n random fields.

function [x, coeff] = generate_variable_field(sig_sz, n, psd_fun, coeff_fun, opt)
    if nargin < 1 || isempty(sig_sz)
        error('sig_sz must be specified');
    end

    if nargin < 2 || isempty(n)
        error('n must be specified');
    end

    if nargin < 3 || isempty(psd_fun)
        psd_fun = {@(r)(ones(size(r)))};
    end

    if nargin < 4 || isempty(coeff_fun)
        coeff_fun = {@randn};
    end

    if nargin < 5 || isempty(opt)
        opt = struct();
    end

    d = numel(sig_sz);

    r = numel(psd_fun);

    if numel(coeff_fun) == 1
        coeff_fun = repmat(coeff_fun, [1 r]);
    elseif numel(coeff_fun) ~= r
        error('coeff_fun must be a cell array of length 1 or r');
    end

    x = zeros([sig_sz n]);

    for l = 1:r
        x_l = generate_field(sig_sz, n, psd_fun{l}, opt);

        coeff(l,:) = coeff_fun{l}([1 n]);

        x_l = bsxfun(@times, x_l, permute(coeff(l,:)', [2:d+1 1]));

        x = x+x_l;
    end
end
