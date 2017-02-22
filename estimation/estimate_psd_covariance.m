% ESTIMATE_PSD_COVARIANCE Estimate covariance of PSDs from periodograms
%
% Usage
%    Sigma_n = estimate_psd_covariance(x_per);
%
% Input
%    x_per: Periodograms obtained from estimate_psd_periodogram.
%       There needs to be more than one periodogram present for this to work.
%       The dimension of the periodograms is taken to be d = ndims(x_per)-1.
%
% Output
%    Sigma_n: An array of size sig_sz-by-sig_sz, where sig_sz is the size of
%       the periodograms in x_per (that is the dimensions 1 through d of
%       x_per). This is the covariance estimate of the PSDs, obtained by
%       reweighting the second moments of the periodograms and subtracting
%       the outer product of the mean periodogram.

function Sigma_n = estimate_psd_covariance(x_per)
    d = ndims(x_per)-1;

    n = size(x_per, d+1);

    sig_sz = size(x_per);
    sig_sz = sig_sz(1:d);

    x_per_half = fourier_full_to_half(x_per, sig_sz);

    C_n = x_per_half*x_per_half'/n;

    mu_n = estimate_psd_mean(x_per);
    mu_n = fourier_full_to_half(mu_n, sig_sz);

    [mask, real_mask] = positive_fourier_mask(sig_sz);

    mult = ones(sum(mask(:))) + diag(1+real_mask(mask));

    Sigma_n = C_n./mult-mu_n*mu_n';

    Sigma_n = fourier_half_to_full(Sigma_n, sig_sz);
    Sigma_n = permute(Sigma_n, [d+1 1:d]);
    Sigma_n = fourier_half_to_full(Sigma_n, sig_sz);
    Sigma_n = permute(Sigma_n, [d+1:2*d 1:d]);
end
