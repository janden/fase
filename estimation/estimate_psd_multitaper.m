% ESTIMATE_PSD_MULTITAPER Estimate power spectral densities (multitaper)
%
% Usage
%    x_mt = estimate_psd_multitaper(x, d, opt);
%
% Input
%    x: An array of size N1-by-...-by-Nd-by-n.
%    d: The number of dimensions along which the signals in x are defined.
%    opt: An options structure containing the fields:
%          - W: The target resolution of the multitaper estimate, specified
%             either as a scalar or as a d-dimensional vector. Each element
%             must be strictly less than 1/2 (default 1/8).
%
% Output
%    x_mt: The estimated power spectral densities of size
%       N1-by-...-by-Nd-by-n obtained using the multitaper estimator.

function x_mt = estimate_psd_multitaper(x, d, opt)
    if nargin < 2 || isempty(d)
        d = 1;
    end

    if nargin < 3 || isempty(opt)
        opt = struct();
    end

    opt = fill_struct(opt, ...
        'W', 1/8);

    if numel(opt.W) == 1
        opt.W = opt.W*ones(1, d);
    elseif numel(opt.W) ~= d
        error('opt.W must be 1 or d');
    end

    if any(opt.W >= 0.5)
        error('opt.W must be strictly smaller than 0.5');
    end

    if ~ismember(exist('dpss'), [2 3 5])
        error('Function dpss is missing');
    end

    sig_sz = size(x);
    sig_sz = sig_sz(1:d);

    E = 1;

    for l = 1:d
        E_l = dpss(sig_sz(l), sig_sz(l)*opt.W(l));

        % Move first and second dimensions into lth and (d+l)th, respectively.
        E_l = permute(E_l, [3:2+(l-1) 1 3+(l-1):2+(l-1)+(d-1) 2]);

        E = bsxfun(@times, E, E_l);
    end

    taper_sz = size(E);
    taper_sz = taper_sz(d+1:2*d);
    taper_len = prod(taper_sz);

    E = reshape(E, [sig_sz taper_len]);

    x_mt = zeros(size(x));

    idx.type = '()';
    idx.subs = repmat({':'}, [1 d]);

    for m = 1:taper_len
        idx.subs{d+1} = m;

        E_m = subsref(E, idx);

        x_tapered = bsxfun(@times, x, E_m);

        x_mt = x_mt + 1/taper_len*estimate_psd_periodogram(x_tapered, d);
    end
end
