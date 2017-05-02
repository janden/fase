% GET_SPIDER_HEADER Get header of a SPIDER file
%
% Usage
%    header = get_spider_header(filename);
%
% Input
%    filename: The filename of the SPIDER file.
%
% Output
%    header: The header structure obtained from the SPIDER file.
%
% Description
%    This function provides a wrapper for the spider_open and spider_close
%    functions.

function header = get_spider_header(filename)
    spider = spider_open(filename);

    header = spider.header;

    spider_close(spider);
end
