clc;clear;
% for i = 1 : 512
%     for j = 1 : 512
%         inp(i,j) = mod((i-1)*(j-1),255);
%     end
% end
type Peppers.txt;
peppers = readmatrix('lena.txt');
peppers(:,513) = [];
figure(1)

imshow(peppers,[]);
title("Original Image");
% ifft2_out_m = ifft2(inp);
% type image_out.txt;
% real_part = readmatrix('image_out.txt');
% type image_out_imag.txt;
% imag_part = readmatrix('image_out_imag.txt');
type ifft_image_out.txt;
our = readmatrix('lena_image_out.txt');
% divide = 512*512;
% our = our ./ divide;
% for k = 1:512
%     for j = 1:512
%         ifft2_out(k,j) = real_part(k,j) + imag_part(k,j)*i;
%     end
% end
% for i = 385:512
%    ifft2_out(i,:) = 0;
% end
% 

% for i = 385:512
%    ifft2_out(:,i) = 0;
% end
fftImage = fft2(peppers);

% window = 30;
% fftImage(1:window, 1:window) = 0;
% fftImage(end-window:end, 1:window) = 0;
% fftImage(1:window, end-window:end) = 0;
% fftImage(end-window:end, end-window:end) = 0;
% tmp = ifft2(fftImage);
% tmp = ifftshift(tmp);
% divide = 512*512;
% out = out ./ divide;
figure(2)
imshow(our,[]);
title("Compressed");
% output = abs(vhdl_fft2_out - real(fft2_ori_image));
% p_res = fft2(p);

% figure(2)
% imshow(ifft2_out,[])
% title("VHDL Output");
