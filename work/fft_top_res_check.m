type peppers.txt;
peppers = readmatrix('peppers.txt');
peppers(:,513) = [];
figure(1)

imshow(peppers,[]);
title("Original Image");
% ifft2_out_m = ifft2(inp);
type ifft1d_image_out.txt;
ifft2_out = readmatrix('ifft1d_image_out.txt');
ifft2_out(:,513)=[];
% p_res = fft2(p);
divide = 512*512;
ifft2_out = ifft2_out ./ divide;
figure(2)
imshow(ifft2_out,[])
title("VHDL Output");