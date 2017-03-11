% VERIFY_MD5_HASHES Verify the MD5 hashes in a directory using a hash file
%
% Usage
%    [verified, files_verified] = verify_md5_hashes(directory, hash_file, ...
%        idx));
%
% Input
%    directory: The root directory containing the files whose MD5 hashes are
%       to be verified.
%    hash_file: The hash file containing the hashes to compare against.
%    idx: A subset of files to check. If empty, all files are checked
%       (default empty).
%
% Output
%    verified: True if all files have verified MD5 hashes.
%    files_verified: A boolean array corresponding to all hashes in hash_file.
%       If the file is missing, the entry is set to false.

function [verified, files_verified] = verify_md5_hashes(directory, ...
    hash_file, idx)
    if nargin < 3
        idx = [];
    end

    files = read_md5_hashes(hash_file);

    if isempty(idx)
        idx = 1:numel(files);
    end

    for k = 1:numel(idx)
        filename = fullfile(directory, files(idx(k)).name);
        if exist(filename, 'file')
            hash = calc_md5_hash(filename);

            files_verified(k) = strcmp(hash, files(idx(k)).hash);
        else
            files_verified(k) = false;
        end
    end

    verified = all(files_verified);
end
