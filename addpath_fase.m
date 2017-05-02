% ADDPATH_FASE Add paths for the FASE package
%
% Usage
%    addpath_fase();

function addpath_fase()
    % Make sure we have the absolute path, not just the relative.
    path_to_here = fileparts(mfilename('fullpath'));

    addp = @(d)(addpath(fullfile(path_to_here, d)));

    addp('estimation');
    addp('examples');
    addp('io');
    addp('simulation');
    addp('utils');
end
