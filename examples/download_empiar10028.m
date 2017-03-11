% DOWNLOAD_EMPIAR10028 Download EMPIAR-10028 dataset
%
% Usage
%    download_empiar10028(url, location);
%
% Input
%    url: The base URL from which the dataset should be downloaded. By default,
%       this is:
%
%          ftp://ftp.ebi.ac.uk/pub/databases/empiar/archive/10028/data/
%             Particles
%
%    location: The location in which the dataset should be stored. By default
%       this is in the subfolder 'data/empiar10028'.
%
% Description
%    This function downloads the EMPIAR-10028 dataset, which is of size 51 GB.

function location = download_empiar10028(url, location)
    if nargin < 1 || isempty(url)
        url = 'ftp://ftp.ebi.ac.uk/pub/databases/empiar/archive/10028/';
    end

    if nargin < 2 || isempty(location)
        location = 'data/empiar10028';
    end

    hash_file = 'examples/datasets/empiar10028_hashes';

    if ~exist(location, 'dir')
        mkdirp(location);
    else
        files = read_md5_hashes(hash_file);

        filenames = {files.name};

        filenames = cellfun(@(x)(fullfile(location, x)), filenames, ...
            'uniformoutput', false);

        if all(cellfun(@(x)(exist(x, 'file')), filenames))
            return;
        end
    end

    particles_dir = 'data/Particles/';

    files = read_md5_hashes('examples/datasets/empiar10028_hashes');

    for k = 1:numel(files)
        filename = fullfile(location, files(k).name);

        subfolder_path = fileparts(filename);

        if ~exist(subfolder_path, 'dir')
            mkdir(subfolder_path);
        end

        file_url = [url particles_dir files(k).name];

        urlwrite(file_url, filename);
    end

    verified = verify_md5_hashes(location, hash_file);

    if ~verified
        warning('Downloaded empiar10028 dataset does not verify MD5 hashes.');
    end
end
