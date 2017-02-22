% ESTIMATE_PSD_MEAN Estimate mean of PSDs
%
% Usage
%    mu_n = estimate_psd_mean(x_psd);
%
% Input
%    x_psd: PSD estimates obtained from one of the estimate_psd* functions.
%
% Output
%    mu_n: The average PSD estimate.

function mu_n = estimate_psd_mean(x_psd)
    d = ndims(x_psd)-1;

    n = size(x_psd, d+1);

    mu_n = sum(x_psd, d+1)/n;
end
