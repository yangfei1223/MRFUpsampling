%close all;
%clear all;
%OriImg = imread('data\KITTI\color.png');
function result = FTSaliencyTerm(OriImg, Height, Width)
OriImg = double(OriImg);
ColorR = OriImg(:,:,1);
ColorG = OriImg(:,:,2);
ColorB = OriImg(:,:,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
s = Height*Width; 
% Set a threshold 
T = 0.008856; 
RGB = [reshape(ColorR,1,s); reshape(ColorG,1,s); reshape(ColorB,1,s)]; 
RGB = double(RGB);
% RGB to XYZ 
MAT = [0.412453 0.357580 0.180423; 
       0.212671 0.715160 0.072169; 
       0.019334 0.119193 0.950227]; 
XYZ = MAT * RGB; 
X = XYZ(1,:) / 0.950456; 
Y = XYZ(2,:); 
Z = XYZ(3,:) / 1.088754; 
XT = X > T; 
YT = Y > T; 
ZT = Z > T; 
fX = XT .* X.^(1/3) + (~XT) .* (7.787 .* X + 16/116); 
% Compute L 
Y3 = Y.^(1/3);  
fY = YT .* Y3 + (~YT) .* (7.787 .* Y + 16/116); 
L  = YT .* (116 * Y3 - 16.0) + (~YT) .* (903.3 * Y); 
fZ = ZT .* Z.^(1/3) + (~ZT) .* (7.787 .* Z + 16/116); 
% Compute a and b 
a = 500 * (fX - fY); 
b = 200 * (fY - fZ); 
L = reshape(L, Height, Width); 
a = reshape(a, Height, Width); 
b = reshape(b, Height, Width); 
labimg = cat(3,L,a,b); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ColorR = labimg(:,:,1);
ColorG = labimg(:,:,2);
ColorB = labimg(:,:,3);
RMean = mean(reshape(ColorR,Height*Width,1));
GMean = mean(reshape(ColorG,Height*Width,1));
BMean = mean(reshape(ColorB,Height*Width,1));
sigma = 1.6;
gausFilter = fspecial('gaussian',[5 5],sigma);
GaussR = imfilter(ColorR,gausFilter,'replicate');
GaussG = imfilter(ColorG,gausFilter,'replicate');
GaussB = imfilter(ColorB,gausFilter,'replicate');
SaliencyR = (RMean - GaussR).^2;
SaliencyG = (GMean - GaussG).^2;
SaliencyB = (BMean - GaussB).^2;
Saliency = SaliencyR + SaliencyG + SaliencyB;
%SaMin = min(reshape(Saliency, s, 1));
%SaMax = max(reshape(Saliency, s, 1));
%result = (Saliency - SaMin) / (SaMax - SaMin);
C = 0.0001;
result = exp (-(1./(C*(Saliency+0.0001))));
