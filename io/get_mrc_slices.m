% GET_MRC_SLICES Open, extract slices from, and close an MRC file
%
% Usage
%    [x, header] = get_mrc_slices(filename, start, num);
%
% Input
%    filename: The filename of the MRC file.
%    start: The starting number of the slices to be extracted (default 0).
%    num: The number of slices to extract. If set to Inf, all slices after
%       start will be returned (default Inf).
%
% Output
%    x: The slices, arranged in an array of size N(1)-by-N(2)-by-n, where
%       N are the slice dimensions from header.N and n are the number of
%       slices extracted.
%    header: The header structure obtained from the MRC file.
%
% Description
%    This function provides a wrapper for the mrc_open, mrc_skip, mrc_read
%    and mrc_close functions.

function [x, header] = get_mrc_slices(filename, start, num)
    if nargin < 2 || isempty(start)
        start = 0;
    end

    if nargin < 3 || isempty(num)
        num = Inf;
    end

    mrc = mrc_open(filename);

    mrc_skip(mrc, start);

    x = mrc_read(mrc, num);

    mrc_close(mrc);

    header = mrc.header;
end
