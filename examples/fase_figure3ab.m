% FASE_FIGURE3AB Generate Figure 3a and 3b from the FASE paper
%
% Usage
%    fase_figure3ab(frank70s_location);
%
% Input
%    location: The location in which the frank70s dataset is stored (default
%       'data/frank70s').
%
% Description
%    Generate Figures 3a and 3b from
%
%       J. Andén and A. Singer, "Factor Analysis for Spectral Estimation,"
%       submitted to SampTA 2017, arXiv preprint arXiv:1702.04672.

function data = fase_figure3ab(frank70s_location)
    if nargin < 1 || isempty(frank70s_location)
        frank70s_location = 'data/frank70s';
    end

    fig_id = 8;

    r = 2;
    W = 1/65;

    n_eig = 16;

    font_size = 36;

    colors = {[0 0.2 0.7], [0 0.7 0.2], [0.7 0 0], [0 0 0]};
    linewidth = 3;
    markersize = 10;

    x = read_frank70s(frank70s_location);

    N = size(x, 1);

    x_mean = mean(x, 3);

    x = bsxfun(@minus, x, x_mean);

    x = bsxfun(@minus, x, mean(mean(x, 1), 2));

    x = x/std(x(:));

    x_per = estimate_psd_periodogram(x, 2, []);

    mu_n = estimate_psd_mean(x_per);
    Sigma_n = estimate_psd_covariance(x_per);

    [V, D] = mdim_eigs(Sigma_n, n_eig, 'la');
    [V, D] = mdim_sort_eig(V, D);

    Vr = V(:,:,1:r);
    lambda = diag(D);

    x_mt = estimate_psd_multitaper(x, 2, struct('W', W));

    x_mt_proj = project_psd(x_mt, Vr);

    x_mt_proj1 = x_mt_proj(:,:,9078);
    x_mt_proj2 = x_mt_proj(:,:,9935);

    mu_n = max(0, mu_n(1:floor(N/2),1));
    x_mt_proj1 = max(0, x_mt_proj1(1:floor(N/2),1));
    x_mt_proj2 = max(0, x_mt_proj2(1:floor(N/2),1));

    data.lambda = lambda;

    data.N = N;
    data.mu_n = mu_n;
    data.x_mt_proj1 = x_mt_proj1;
    data.x_mt_proj2 = x_mt_proj2;

    figure(fig_id);
    set(gcf, 'position', [400 400 800 400]);
    set(gcf, 'paperposition', [0 0 8 4]);
    h = bar(data.lambda/data.N^4);
    ylim([0 4e-6]);
    xlim([1 16]+[-0.6 0.6]);
    set(gca, 'fontsize', font_size);
    set(gca, 'xtick', [1 16], 'ytick', [0 2e-6 4e-6], 'yticklabel', {'0', '2e-6', '4e-6'});
    set(h, 'facecolor', colors{4});

    print('-depsc', 'output/fase_figure3a.eps');

    fig_id = fig_id+1;

    freqs = [0:floor(data.N/2)-1]/data.N;
    [~, label_ind] = min(abs(freqs-0.05));

    figure(fig_id);
    set(gcf, 'position', [400 400 800 400]);
    set(gcf, 'paperposition', [0 0 8 4]);
    hold on;
    h(1) = plot(freqs, data.mu_n/data.N^2, 'color', colors{1}, ...
        'linewidth', linewidth, 'linestyle', '--');
    h(2) = plot(freqs, data.x_mt_proj1/data.N^2, 'color', colors{2}, ...
        'linewidth', linewidth, 'linestyle', '-');
    h(3) = plot(freqs(label_ind), data.x_mt_proj1(label_ind)/data.N^2, ...
            'color', colors{2}, 'linewidth', linewidth, 'linestyle', '-', ...
            'marker', 's', 'markersize', 15);
    h(4) = plot(freqs, data.x_mt_proj2/data.N^2, 'color', colors{3}, ...
        'linewidth', linewidth, 'linestyle', '-');
    h(5) = plot(freqs(label_ind), data.x_mt_proj2(label_ind)/data.N^2, ...
            'color', colors{3}, 'linewidth', linewidth, 'linestyle', '-', ...
            'marker', 'o', 'markersize', 15);
    hold off;
    ylim([0 12e-4]);
    xlim([0 data.N/4]/data.N);
    set(gca, 'fontsize', font_size);
    set(gca, 'xtick', [0:0.05:0.25], 'ytick', [0 5e-4 10e-4], 'yticklabel', {'0', '5e-4', '1e-3'});

    hleg = legend(h([1 3 5]), 'Mean', '#9078', '#9935', 'location', 'northeast');
    legend boxoff;
    pos = get(hleg, 'position');
    set(hleg, 'position', [pos(1)-0.15 pos(2)-0.10 pos(3)+0.1 pos(4)+0.05]);

    print('-depsc', 'output/fase_figure3b.eps');
end
