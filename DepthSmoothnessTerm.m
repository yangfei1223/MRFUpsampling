function [ result ] = DepthSmoothnessTerm( OriImg, Height, Width )

OriImg = double(OriImg);
C1 = 0.001;
N = 10;      %º∆À„25*25¡⁄”Ú
%¿©¥Û±ﬂΩÁ
ComImg = [zeros(N,Width + N*2); zeros(Height,N), OriImg, zeros(Height,N); zeros(N,Width + N*2)]; 
ResImg = zeros(Height, Width);
%…œ“∆
for i=1:N
    TmpImg = ComImg(N+1+i:N+Height+i , N+1:N+Width);
    DifImg = (TmpImg - OriImg).^2;
    ResImg = ResImg + DifImg;
end
%œ¬“∆
for i=1:N
    TmpImg = ComImg(N+1-i:N+Height-i , N+1:N+Width);
    DifImg = (TmpImg - OriImg).^2;
    ResImg = ResImg + DifImg;
end
%◊Û“∆
%for i=1:N
%    TmpImg = ComImg(N+1:N+Height , N+1+i:N+Width+i);
%    DifImg = (TmpImg - OriImg).^2;
%    ResImg = ResImg + DifImg;
%end
%”““∆
%for i=1:N
%    TmpImg = ComImg(N+1:N+Height , N+1-i:N+Width-i);
%    DifImg = (TmpImg - OriImg).^2;
%    ResImg = ResImg + DifImg;
%end

result = exp(-C1*ResImg);

end

