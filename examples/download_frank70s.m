% DOWNLOAD_FRANK70S Download frank70s dataset
%
% Usage
%    download_frank70s(url, location);
%
% Input
%    url: The URL from which the dataset should be downloaded. By default,
%       this is:
%
%          ftp://ftp.ebi.ac.uk/pub/databases/emtest/SPIDER_FRANK_data/
%             J-Frank_70s_real_data.tar
%
%    location: The location in which the dataset should be stored. By default
%       this is in the subfolder 'data/frank70s'.
%
% Description
%    This function downloads the frank70s dataset, which is of size ~700 MB.
%    Since it comes in a TAR archive, double this amount is needed on the disk
%    for successful download and extraction.

function location = download_frank70s(url, location)
    if nargin < 1 || isempty(url)
        url = 'ftp://ftp.ebi.ac.uk/pub/databases/emtest/SPIDER_FRANK_data/J-Frank_70s_real_data.tar';
    end

    if nargin < 2 || isempty(location)
        location = 'data/frank70s';
    end

    hash_file = 'examples/datasets/frank70s_hashes';

    if ~exist(location, 'dir')
        mkdir(location);
    else
        return;
    end

    tar_file = fullfile(location, 'data.tar');

    urlwrite(url, tar_file);

    untar(tar_file, location);

    delete(tar_file);

    movefile(fullfile(location, 'win', '*.dat'), location)

    rmdir(fullfile(location, 'win'));

    verified = verify_md5_hashes(location, hash_file);

    if ~verified
        warning('Downloaded frank70s dataset does not verify MD5 hashes.');
    end
end
