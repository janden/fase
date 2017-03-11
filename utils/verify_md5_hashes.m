% VERIFY_MD5_HASHES Verify the MD5 hashes in a directory using a hash file
%
% Usage
%    [verified, files_verified] = verify_md5_hashes(directory, hash_file);
%
% Input
%    directory: The root directory containing the files whose MD5 hashes are
%       to be verified.
%    hash_file: The hash file containing the hashes to compare against.
%
% Output
%    verified: True if all files have verified MD5 hashes.
%    files_verified: A boolean array corresponding to all hashes in hash_file.
%       If the file is missing, the entry is set to false.

function [verified, files_verified] = verify_md5_hashes(directory, hash_file)
    files = read_md5_hashes(hash_file);

    for k = 1:numel(files)
        filename = fullfile(directory, files(k).name);
        if exist(filename, 'file')
            hash = calc_md5_hash(filename);

            files_verified(k) = strcmp(hash, files(k).hash);
        else
            files_verified(k) = false;
        end
    end

    verified = all(files_verified);
end
