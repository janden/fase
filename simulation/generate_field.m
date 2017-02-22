% GENERATE_FIELD Generate linear fields from power spectral densities
%
% Usage
%    x = generate_field(sig_sz, psd_fun, opt);
%
% Input
%    sig_sz: The desired size of the generated fields.
%    psd_fun: A cell array of n function handles, each corresponding to the
%       desired power spectral distribution of an individual field, defined
%       over the domain [-1/2, 1/2]^d.
%    opt: An options structure containing the fields:
%          - gen_sig_sz: The size of the generating white noise field. This
%             has to be larger than or equal to sig_sz and it is recommended
%             that is be at least twice as large to reduce periodization
%             effects (default 2*sig_sz).
%          - gen_fun: A function handle taking a size as an input and
%             returning an array of that size containing white noise (default
%             @randn).
%
% Output
%    x: An array of size sig_sz-by-n containing the generated fields.
%
% Description
%    For each of the n function handles in psd_fun, a white noise field of
%    size gen_sig_sz is created. Its Fourier transform is then multiplied by
%    the square root of the corresponding psd_fun function handle, evaluated
%    at the Fourier frequency grid points. The Fourier transform is then
%    inverted, and the topmost sig_sz subarray is extracted. As gen_sig_sz
%    becomes larger, this will converge to a stationary field with the
%    desired power spectral density.

function x = generate_field(sig_sz, psd_fun, opt)
    if nargin < 2 || isempty(psd_fun)
        psd_fun = @(r)(ones(size(r)));
    end

    if nargin < 3 || isempty(opt)
        opt = struct();
    end

    opt = fill_struct(opt, ...
        'gen_sig_sz', 2*sig_sz, ...
        'gen_fun', @randn);

    d = numel(sig_sz);

    n = numel(psd_fun);

    rngs = {};
    for l = 1:d
        rngs{l} = [0:floor(opt.gen_sig_sz(l)/2) ...
                   -ceil(opt.gen_sig_sz(l)/2)+1:-1];
        rngs{l} = rngs{l}/opt.gen_sig_sz(l);
    end

    grids = cell(1, d);
    [grids{:}] = ndgrid(rngs{:});

    x = zeros([sig_sz n]);

    idx_ref.type = '()';
    idx_ref.subs = cell(1, d);
    for l = 1:d
        idx_ref.subs{l} = 1:sig_sz(l);
    end

    idx_asgn.type = '()';
    idx_asgn.subs = repmat({':'}, 1, d);

    for s = 1:n
        w = opt.gen_fun(opt.gen_sig_sz);

        wf = fftd(w, d);
        xf_s = wf.*sqrt(psd_fun{s}(grids{:}));
        x_s = ifftd(xf_s, d);

        idx_asgn.subs{d+1} = s;

        x = subsasgn(x, idx_asgn, subsref(x_s, idx_ref));
    end
end
