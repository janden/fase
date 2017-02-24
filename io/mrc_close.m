% MRC_CLOSE Closes an MRC file
%
% Usage
%    mrc_close(mrc);
%
% Input
%    mrc: The MRC structure, typically obtained from mrc_open.

function mrc_close(mrc)
    fclose(mrc.fd);
end
