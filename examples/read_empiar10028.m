% READ_EMPIAR10028 Read in the EMPIAR-10028 dataset
%
% Usage
%    x = read_empiar10028(location);
%
% Input
%    location: The location in which the dataset is stored (default
%       'data/empiar10028').
%
% Output
%    x: The images of the EMPIAR-10028 dataset, arranged in a three-dimensional
%       array.

function x = read_empiar10028(location)
    if nargin < 1 || isempty(location)
        location = 'data/empiar10028';
    end

    hash_file = 'examples/datasets/empiar10028_hashes';

    files = read_md5_hashes(hash_file);

    filenames = arrayfun(@(x)(fullfile(location, x.name)), files, ...
        'uniformoutput', false);

    [~, data_type] = get_mrc_header(filenames{1});

    headers = cellfun(@get_mrc_header, filenames);

    Ns = [headers.N];

    n_slices = Ns(3,:);

    nx = headers(1).N(1);
    ny = headers(1).N(2);

    idx = cumsum([1 n_slices(1:end-1)]);

    x = zeros([nx ny sum(n_slices)], data_type);

    for k = 1:numel(filenames)
        x(:,:,idx(k):idx(k)+n_slices(k)-1) = get_mrc_slices(filenames{k});
    end
end
