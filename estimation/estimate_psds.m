% ESTIMATE_PSDS Estimate power spectral densities
%
% Usage
%    x_psds = estimate_psds(x, d, opt);
%
% Input
%    x: An array of size N1-by-...-by-Nd-by-n.
%    d: The number of dimensions along which the signals in x are defined.
%    opt: An options structure containing the fields:
%          - type: Specifies which type of estimator should be used. Currently
%             the only option is 'periodogram' (default 'periodogram').
%
% Output
%    x_psds: The estimated power spectral densities of size
%       N1-by-...-by-Nd-by-n.

function x_psds = estimate_psds(x, d, opt)
    if nargin < 2 || isempty(d)
        d = 1;
    end

    if nargin < 3 || isempty(opt)
        opt = struct();
    end

    opt = fill_struct(opt, ...
        'type', 'periodogram');

    if strcmp(opt.type, 'periodogram')
        x_psds = estimate_psds_periodogram(x, d, opt);
    end
end
