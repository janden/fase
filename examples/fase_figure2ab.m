% FASE_FIGURE2AB Generate Figure 2a and 2b from the FASE paper
%
% Usage
%    fase_figure2ab();
%
% Description
%    Generate Figures 2a and 2b from
%
%       J. Andén and A. Singer, "Factor Analysis for Spectral Estimation,"
%       submitted to SampTA 2017, arXiv preprint arXiv:1702.04672.

function fase_figure2ab()
    fig_id = 3;

    N = 32;
    n = 1024;

    font_size = 16;

    % Define the two PSDs that we will use and generate the data.
    psd_fun = {};
    psd_fun{1} = @(x, y)(2*double(hypot(x, y)<0.125));
    psd_fun{2} = @(x, y)(1./(1+4*hypot(x, y)));

    [x, coeff] = generate_variable_field(N*ones(1, 2), n, psd_fun, [], []);

    % To calculate the correlations between all the PSDS, it suffices to do
    % the calculation for the two base PSDs.
    inner_prod = @(f1,f2)(dblquad(@(x, y)(f1(x, y).*f2(x, y)), 0, 1/2, 0, 1/2));

    A = cellfun(inner_prod, repmat(psd_fun', 1, 2), repmat(psd_fun, 2, 1));

    coeff_sq = abs(coeff).^2;

    R = chol(A);

    psd_norm = sqrt(sum((R*coeff_sq).^2, 1));

    % Find the PSD which correlates the worst with the first PSD in the
    % generated dataset.
    corr1 = (coeff_sq(:,1)'*A*coeff_sq)./(psd_norm(1)*psd_norm);
    [~, ind1] = min(corr1);

    % Find the PSD which correlates the worst with the previous one.
    corr2 = (coeff_sq(:,ind1)'*A*coeff_sq)./(psd_norm(ind1)*psd_norm);
    [~, ind2] = min(corr2);

    % Display the sample images from these PSDs.
    figure(fig_id);
    imagesc(x(:,:,ind1));
    colormap gray;
    axis equal off;

    print('-dpng', 'output/fase_figure2a_top.png');

    fig_id = fig_id+1;

    figure(fig_id);
    imagesc(x(:,:,ind2));
    colormap gray;
    axis equal off;

    print('-dpng', 'output/fase_figure2a_bottom.png');

    fig_id = fig_id+1;

    % Calculate the periodogram and estimate the PSD covariance.
    x_per = estimate_psd_periodogram(x, 2);
    Sigma_n = estimate_psd_covariance(x_per);

    % Calculate the top eigenvalues and display them.
    [~, D] = mdim_eig(Sigma_n);
    lambda = diag(D);
    lambda = sort(lambda, 'descend');

    figure(fig_id);
    bar(lambda(1:16));
    colormap('gray');
    set(gca, 'xtick', 1:16);
    set(gca, 'ytick', 0:100:500);
    set(gca, 'fontsize', font_size);
    xlim([1 16]+[-0.6 0.6]);

    print('-dpng', 'output/fase_figure2b.png');

    fig_id = fig_id+1;
end
