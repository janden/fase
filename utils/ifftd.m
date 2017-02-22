% IFFTD Fast inverse Fourier transform in d dimensions
%
% Usage
%    x = ifftd(xf, d);
%
% Input
%    xf: The Fourier transform array to be inverse transformed.
%    d: The number of dimensions along which to transform.
%
% Output
%    x: The inverse discrete Fourier transform of xf along dimensions 1 
%       through d.

function x = ifftd(xf, d)
    x = xf;
    for l = 1:d
        x = ifft(x, [], l);
    end
end
