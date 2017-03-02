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

function download_empiar10028(url, location)
    if nargin < 1 || isempty(url)
        url = 'ftp://ftp.ebi.ac.uk/pub/databases/empiar/archive/10028/';
    end

    if nargin < 2 || isempty(location)
        location = 'data/empiar10028';
    end

    if ~exist(location, 'dir')
        mkdir(location);
    end

    particles_dir = 'data/Particles/';

    subfolders{1} = 'MRC_0601/';
    counts(1) = 600;

    subfolders{2} = 'MRC_1901/';
    counts(2) = 481;

    file_fmt = '%03d_particles_shiny_nb50_new.mrcs';

    for folder_ind = 1:numel(subfolders)
        subfolder_path = fullfile(location, subfolders{folder_ind});
        if ~exist(subfolder_path, 'dir')
            mkdir(subfolder_path);
        end

        for k = 1:counts(folder_ind)
            file = sprintf(file_fmt, k);

            file_url = [url particles_dir subfolders{folder_ind} file];
            file_path = fullfile(subfolder_path, file);

            urlwrite(file_url, file_path);
        end
    end
end
