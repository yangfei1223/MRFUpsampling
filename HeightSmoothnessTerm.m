function [ result ] = HeightSmoothnessTerm( OriImg, Height, Width )

OriImg = double(OriImg);
C1 = 0.01;
N = 5;      %º∆À„25*25¡⁄”Ú
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
for i=1:N
    TmpImg = ComImg(N+1:N+Height , N+1+i:N+Width+i);
    DifImg = (TmpImg - OriImg).^2;
    ResImg = ResImg + DifImg;
end
%”““∆
for i=1:N
    TmpImg = ComImg(N+1:N+Height , N+1-i:N+Width-i);
    DifImg = (TmpImg - OriImg).^2;
    ResImg = ResImg + DifImg;
end
%result = exp(-C1*ResImg);
%SaMin = min(reshape(ResImg, Height*Width, 1));
%SaMax = max(reshape(ResImg, Height*Width, 1));
%result = (ResImg - SaMin) / (SaMax - SaMin);

C = 0.01;
result = exp (-(1./(C*(ResImg+0.0001))));

end

