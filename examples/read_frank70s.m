% READ_FRANK70S Read in the frank70s dataset
%
% Usage
%    x = read_frank70s(location);
%
% Input
%    location: The location in which the dataset is stored (default
%       'data/frank70s').
%
% Output
%    x: The images of the frank70s dataset, arranged in a three-dimensional
%       array.

function x = read_frank70s(location)
    if nargin < 1 || isempty(location)
        location = 'data/frank70s';
    end

    hash_file = 'examples/datasets/frank70s_hashes';

    files = read_md5_hashes(hash_file);

    filenames = arrayfun(@(x)(fullfile(location, x.name)), files, ...
        'uniformoutput', false);

    headers = cellfun(@get_spider_header, filenames);

    n_slices = [headers.nz];

    nx = headers(1).nx;
    ny = headers(1).ny;

    idx = cumsum([1 n_slices(1:end-1)]);

    x = zeros([nx ny sum(n_slices)], 'single');

    for k = 1:numel(filenames)
        x(:,:,idx(k):idx(k)+n_slices(k)-1) = get_spider_slices(filenames{k});
    end
end
