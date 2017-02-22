% ESTIMATE_PSDS_PERIODOGRAM Estimate power spectral densities (periodogram)
%
% Usage
%    x_psds = estimate_psds_periodogram(x, d, opt);
%
% Input
%    x: An array of size N1-by-...-by-Nd-by-n.
%    d: The number of dimensions along which the signals in x are defined.
%    opt: An options structure. Currently no fields are supported.
%
% Output
%    x_psds: The estimated power spectral densities of size
%       N1-by-...-by-Nd-by-n obtained using the periodogram estimator.

function x_psds = estimate_psds_periodogram(x, d, opt)
    if nargin < 2 || isempty(d)
        d = 1;
    end

    if nargin < 3 || isempty(opt)
        opt = struct();
    end

    sig_sz = size(x);
    sig_sz = sig_sz(1:d);

    xf = fftd(x, d);

    x_psds = 1/prod(sig_sz)*abs(xf).^2;
end
