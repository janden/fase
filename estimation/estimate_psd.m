% ESTIMATE_PSD Estimate power spectral densities
%
% Usage
%    x_psd = estimate_psd(x, d, opt);
%
% Input
%    x: An array of size N1-by-...-by-Nd-by-n.
%    d: The number of dimensions along which the signals in x are defined.
%    opt: An options structure containing the fields:
%          - type: Specifies which type of estimator should be used. Currently
%             the only option is 'periodogram' (default 'periodogram').
%
% Output
%    x_psd: The estimated power spectral densities of size
%       N1-by-...-by-Nd-by-n.

function x_psd = estimate_psd(x, d, opt)
    if nargin < 2 || isempty(d)
        d = 1;
    end

    if nargin < 3 || isempty(opt)
        opt = struct();
    end

    opt = fill_struct(opt, ...
        'type', 'periodogram');

    if strcmp(opt.type, 'periodogram')
        x_psd = estimate_psd_periodogram(x, d, opt);
    end
end
