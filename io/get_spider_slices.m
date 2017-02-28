% GET_SPIDER_SLICES Open, extract slices from, and close a SPIDER file
%
% Usage
%    [x, header] = get_spider_slices(filename, start, num);
%
% Input
%    filename: The filename of the SPIDER file.
%    start: The starting number of the slices to be extracted (default 0).
%    num: The number of slices to extract. If set to Inf, all slices after
%       start will be returned (default Inf).
%
% Output
%    x: The slices, arranged in an array of size nx-by-ny-by-n, where nx and
%       ny are the slice dimensions from header and n are the number of slices
%       extracted.
%    header: The header structure obtained from the SPIDER file.
%
% Description
%    This function provides a wrapper for the spider_open, spider_skip, spider_read
%    and spider_close functions.

function [x, header] = get_spider_slices(filename, start, num)
    if nargin < 2 || isempty(start)
        start = 0;
    end

    if nargin < 3 || isempty(num)
        num = Inf;
    end

    spider = spider_open(filename);

    spider_skip(spider, start);

    x = spider_read(spider, num);

    spider_close(spider);

    header = spider.header;
end
