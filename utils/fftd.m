% FFTD Fast Fourier transform in d dimensions
%
% Usage
%    xf = fftd(x, d);
%
% Input
%    x: The signal array to be transformed.
%    d: The number of dimensions along which to transform.
%
% Output
%    xf: The discrete Fourier transform of x along dimensions 1 through d.

function xf = fftd(x, d)
    xf = x;
    for l = 1:d
        xf = fft(xf, [], l);
    end
end
