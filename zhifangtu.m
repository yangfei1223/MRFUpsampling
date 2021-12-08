clc; clear all; close all;
ImgIndex = 386;
I = imread(['./result/' num2str(ImgIndex) '/result.png']);
[n,xout] = hist(I(:), 0:255);
figure; 
subplot(1, 1, 1); imhist(I, 256); xlim([0 255]);