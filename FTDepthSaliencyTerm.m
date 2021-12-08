%close all;
%clear all;
%OriImg = imread('data\KITTI\color.png');
function result = FTDepthSaliencyTerm(OriImg, Height, Width)
OriImg = double(OriImg);
Mean = mean(reshape(OriImg,Height*Width,1));
sigma = 1.6;
gausFilter = fspecial('gaussian',[5 5],sigma);
Gauss = imfilter(OriImg,gausFilter,'replicate');
Saliency = (Mean - Gauss).^2;
SaMin = min(reshape(Saliency, Height*Width, 1));
SaMax = max(reshape(Saliency, Height*Width, 1));
result = (Saliency - SaMin) / (SaMax - SaMin);
