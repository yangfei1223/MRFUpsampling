

ImgIndex = 244;
for ImgIndex=181:446
close all;
ss = sprintf('%010d.png',ImgIndex);
OriImg = imread(['.\data\KITTI\all\' ss]);
%figure;
%imshow(OriImg);
DepImg = imread(['data\KITTI\allinit\depth' num2str(ImgIndex) '.png']);
%figure;
%imshow(DepImg);
HeiImg = imread(['data\KITTI\allinit\heightinit' num2str(ImgIndex) '.png']);
%figure;
%imshow(HeiImg);
%%%%%%%%%%%%%%%%%%%%%%%%%
[Height Width K] = size(OriImg);
s = Height*Width; 
SalTerm = FTSaliencyTerm(OriImg, Height, Width);
%figure;
%imshow(SalTerm);
imwrite(uint8(SalTerm*255),['./result/res/SalTerm' num2str(ImgIndex) '.png']);
%tt = FTDepthSaliencyTerm(DepImg, Height, Width);
%%%%%%%%%%%%%%%%%%%%%%%%%
%DepTerm = DepthTerm(DepImg, Height, Width);
%figure;
%imshow(DepTerm);
%imwrite(uint8(DepTerm),['./result/' num2str(ImgIndex) '/DepTerm.png']);
%%%%%%%%%%%%%%%%%%%%%%%%%%
DepSmTerm = DepthSmoothnessTerm(DepImg, Height, Width);
%figure;
%imshow(DepSmTerm);
imwrite(uint8(DepSmTerm*255),['./result/res/DepSmTerm' num2str(ImgIndex) '.png']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
HeiSmTerm = HeightSmoothnessTerm(HeiImg, Height, Width);
%HeiSmTerm = 1 - HeiSmTerm;
%figure;
%imshow(HeiSmTerm);
imwrite(uint8(HeiSmTerm*255),['./result/res/HeiSmTerm' num2str(ImgIndex) '.png']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
HeightTerm = HeiTerm(HeiImg, Height, Width, DepImg);
%figure;
%imshow(HeightTerm);
imwrite(uint8(HeightTerm*255),['./result/res/HeightTerm' num2str(ImgIndex) '.png']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%K1 = 0.15;
%K2 = 0.6;
%K3 = 0.05;
%K4 = 0.2;
%Result = K1*SalTerm + K2*DepTerm + K3*DepSmTerm + K4*HeightTerm;
K1 = 0.2;
K2 = 0.1;
K3 = 0;
K4 = 0.7;
Result = K1*SalTerm + K2*HeiSmTerm + K3*DepSmTerm + K4*HeightTerm;
SaMin = min(reshape(Result, s, 1));
SaMax = max(reshape(Result, s, 1));
result = (Result - SaMin) / (SaMax - SaMin);
TD = 150;
TH = 180;
result(DepImg > TD) = 1;
result(HeiImg > TH) = 1;
%figure;
%imshow(result);
imwrite(uint8(result*255),['./result/res/result' num2str(ImgIndex) '.png']);

SalTerm(SalTerm<0.2) = 0;
SalTerm(SalTerm>=0.2) = 1;
%figure;
%imshow(SalTerm);
imwrite(uint8(SalTerm*255),['./result/res/SalTermBin' num2str(ImgIndex) '.png']);


ResT = 0.3;
result(result<ResT) = 0;
result(result>=ResT) = 1;
%figure;
%imshow(result);
imwrite(uint8(result*255),['./result/res/resultBin' num2str(ImgIndex) '.png']);

for i=1:Height
    for j=1:Width
        if result(i,j) == 0
            OriImg(i,j,1) = 255;
            OriImg(i,j,2) = 0;
            OriImg(i,j,3) = 0;
        end;
    end
end
%figure;
%imshow(OriImg);
imwrite(uint8(OriImg),['./result/res/TraversabilityAnalysis' num2str(ImgIndex) '.png']);
ImgIndex
end
