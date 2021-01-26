clc;clear;

vhdl_fft2_out = readmatrix('C:\Users\sin29\Desktop\output\Baboon\fft2d\18\baboon_image_out');
vhdl_fft2_out(:,513) = [];


ori_image = readmatrix('baboon.txt');
ori_image(:,513) = [];
% for i = 1 : 512
%     fft_out(i,:) = fft(ori_image(i,:));
% end
% 
% for i = 1 : 512
%     fft_out(i,:) = ifft(fft_out(i,:));
% end

% fft2_ori_image = fft2(ori_image);

% 
output = abs(vhdl_fft2_out - real(ori_image));
snr = sum(output,'all')/(512*512);
% % test = snr( real(fft2_ori_image),vhdl_fft2_out);
figure(1)
imshow(vhdl_fft2_out,[]);
title('IFFT Output')