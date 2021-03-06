% MRC_READ Read from MRC file
%
% Usage
%    x = mrc_read(mrc, n);
%
% Input
%    mrc: The MRC structure obtained from mrc_open.
%    n: The number of slices to read in. If set to Inf, all remaining slices
%       in the file are read (default Inf).
%
% Output
%    x: An array of size N(1)-by-N(2)-by-n, where N are the slice dimensions
%       from the MRC header found in mrc.header.N and n is the number of
%       slices acutally read.

function x = mrc_read(mrc, n)
    if nargin < 2 || isempty(n)
        n = Inf;
    end
    N = mrc.header.N(1:2);

    precision = sprintf('%s=>%s', mrc.data_type, mrc.data_type);

    [x, count] = fread(mrc.fd, prod(N)*n, precision);

    x = reshape(x, [N' count/prod(N)]);
end
