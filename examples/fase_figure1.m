% FASE_FIGURE1 Generate Figure 1 from the FASE paper
%
% Usage
%    fase_figure1();
%
% Description
%    Generate Figure 1 from
%
%       J. Andén and A. Singer, "Factor Analysis for Spectral Estimation,"
%       submitted to SampTA 2017, arXiv preprint arXiv:1702.04672.

function fase_figure1()
    idx = [9078 9935];

    location = download_frank70s();

    if ~exist('output', 'dir')
        mkdir('output');
    end

    im = {};

    fmt = fullfile(location, 'ser%05d.dat');

    for k = 1:numel(idx)
        filename = sprintf(fmt, idx(k));

        im{k} = get_spider_slices(filename);

        im{k} = im{k}-min(im{k}(:));
        im{k} = im{k}/max(im{k}(:));

        im{k} = single(im{k});

        imagename = sprintf('output/fase_figure1%c.png', 'a'+(k-1));

        imwrite(im{k}, imagename);
    end
end
