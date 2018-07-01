% flow = deepflow2(image1, image2, match, options)
%
% "Compute the flow between two images, eventually using given matches.
%
% "Images are HxWx3 single matrices.
% "Match is an optional argument ([] by default), where each row starts by x1 y1 x2 y2.
% "Options is an optional string argument ('' by default), to set the options. Type deepflow2() to see the list of available options.
%
% "The function returns the optical flow as a HxWx2 single matrix.

im1 = single(imread('sintel1.png'));
im2 = single(imread('sintel2.png'));
matches = deepmatching(im1, im2);
flow = deepflow2(im1, im2, matches, '-sintel');