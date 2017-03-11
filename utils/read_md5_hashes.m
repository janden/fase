% READ_MD5_HASHES Read MD5 hashes from a file
%
% Usage
%    files = read_md5_hashes(hash_file);
%
% Input
%    hash_file: The name of the file containing the hashes.
%
% Output
%    files: A struct array with two fields: name and hash. The name field
%       contains the filename while hash contains its MD5 hash.
%
% Description
%    The hash file should be in the format output by the GNU md5sum utility.

function files = read_md5_hashes(hash_file)
    f = fopen(hash_file, 'r');

    files = [];

    while ~feof(f)
        line = fgetl(f);

        nfile.name = line(35:end);
        nfile.hash = line(1:32);

        files = cat(1, files, nfile);
    end

    fclose(f);
end
