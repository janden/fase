% GET_MRC_HEADER Get header of an MRC file
%
% Usage
%    [header, data_type] = get_mrc_header(filename);
%
% Input
%    filename: The filename of the MRC file.
%
% Output
%    header: The header structure obtained from the MRC file.
%    data_type: The datatype of the MRC file. One of 'schar', 'int16', or
%       'float32'.
%
% Description
%    This function provides a wrapper for the mrc_open and mrc_close
%    functions.

function [header, data_type] = get_mrc_header(filename)
    mrc = mrc_open(filename);

    header = mrc.header;

    data_type = mrc.data_type;

    mrc_close(mrc);
end
