% FASE_FIGURE2CD Generate Figure 2c and 2d from the FASE paper
%
% Usage
%    fase_figure2cd();
%
% Description
%    Generate Figures 2c and 2d from
%
%       J. Andén and A. Singer, "Factor Analysis for Spectral Estimation,"
%       submitted to SampTA 2017, arXiv preprint arXiv:1702.04672.

function data = fase_figure2cd()
    fig_id = 6;

    trials = 32;

    ns = 2.^[5:18];
    Ns = [32 64];
    W1 = 1/16;
    W2 = 1/64;

    font_size = 24;

    colors = {[0 0.2 0.7], [0 0.7 0.2], [0.7 0 0], [0 0 0]};
    linewidth = 3;
    markersize = 10;

    % Define the two PSDs that we will use.
    psd_fun = {};
    psd_fun{1} = @(x, y)(2*double(hypot(x, y)<0.125));
    psd_fun{2} = @(x, y)(1./(1+4*hypot(x, y)));

    r = numel(psd_fun);

    for trial = 1:trials
        randn('state', trial);

        for N_ind = 1:numel(Ns)
            N = Ns(N_ind);

            % Rasterize the PSDs on the grid of resolution N.
            [X, Y] = ndgrid([0:N/2 -N/2+1:-1], [0:N/2 -N/2+1:-1]);
            X = X/N;
            Y = Y/N;

            psd = cellfun(@(f)(f(X, Y)), psd_fun, 'uniformoutput', false);
            psd = cell2mat(permute(psd, [1 3 2]));

            for n_ind = 1:numel(ns)
                n = ns(n_ind);

                % Generate noise fields from given PSDs.
                [x, coeff] = generate_variable_field(N*ones(1, 2), n, psd_fun);

                % Calculate ground truth PSDs.
                coeff_sq = abs(coeff).^2;

                psd_true = reshape(psd, [N^2 r])*coeff_sq;
                psd_true = reshape(psd_true, [N*ones(1, 2) n]);

                % Calculate periodogram and estimate covariance.
                x_per = estimate_psd_periodogram(x, 2, []);

                Sigma_n = estimate_psd_covariance(x_per);

                % Extract top eigenvalues and eigenvectors.
                [V, D] = mdim_eig(Sigma_n);
                [V, D] = mdim_sort_eig(V, D);

                V = V(:,:,1:r);

                % Calculate multitaper PSD estimates. One with a large (W1)
                % and one with a small (W2) bandwidth. The large bandwidth is
                % used just by itself while the small bandwidth is projected
                % to obtaina both low bias and low variance.
                x_mt1 = estimate_psd_multitaper(x, 2, struct('W', W1));

                x_mt2 = estimate_psd_multitaper(x, 2, struct('W', W2));

                x_mt2_mean = estimate_psd_mean(x_mt2);

                x_mt2_proj = project_psd(x_mt2, V);

                x_mt2_oracle_proj = project_psd(x_mt2, psd);

                % Calculate the mean absolute error of the PSD estimates.
                mae = @(x)(norm(x(:), 1)/numel(x));

                mae_mt2_mean(n_ind,N_ind,trial) = ...
                    mae(bsxfun(@minus, x_mt2_mean, psd_true));
                mae_mt1(n_ind,N_ind,trial) = ...
                    mae(x_mt1-psd_true);
                mae_mt2_proj(n_ind,N_ind,trial) = ...
                    mae(x_mt2_proj-psd_true);
                mae_mt2_oracle_proj(n_ind,N_ind,trial) = ...
                    mae(x_mt2_oracle_proj-psd_true);
            end
        end
    end

    data.Ns = Ns;
    data.ns = ns;
    data.mae_mt2_mean = mae_mt2_mean;
    data.mae_mt1 = mae_mt1;
    data.mae_mt2_proj = mae_mt2_proj;
    data.mae_mt2_oracle_proj = mae_mt2_oracle_proj;

    % Plot the mean absolut errors as a function of n for each resolution N.
    for N_ind = 1:numel(data.Ns)
        figure(fig_id);
        hold on;
        loglog(data.ns, mean(data.mae_mt2_mean(:,N_ind,:), 3), ...
            'color', colors{1}, ...
            'linewidth', linewidth, ...
            'linestyle', '-', ...
            'marker', 's', ...
            'markersize', markersize);
        loglog(data.ns, mean(data.mae_mt1(:,N_ind,:), 3), ...
            'color', colors{2}, ...
            'linewidth', linewidth, ...
            'linestyle', '-', ...
            'marker', 'o', ...
            'markersize', markersize);
        loglog(data.ns, mean(data.mae_mt2_proj(:,N_ind,:), 3), ...
            'color', colors{3}, ...
            'linewidth', linewidth, ...
            'linestyle', '-', ...
            'marker', '*', ...
            'markersize', markersize);
        loglog(data.ns, mean(data.mae_mt2_oracle_proj(:,N_ind,:), 3), ...
            'color', colors{4}, ...
            'linewidth', linewidth, ...
            'linestyle', '-', ...
            'marker', 'd', ...
            'markersize', markersize);
        hold off;
        ylim([1e-2 1e0]);
        xlim([data.ns(1) data.ns(end)]);
        set(gca, 'fontsize', font_size);
        set(gca, 'xtick', [1e2 1e3 1e4 1e5]);
        set(gca, 'ytick', [1e-2 1e-1 1e0]);

        print('-depsc', sprintf('output/fase_figure2%c.eps', 'c'+(N_ind-1)));

        fig_id = fig_id+1;
    end
end
