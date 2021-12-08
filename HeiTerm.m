function [result] = HeiTerm(OriImg, Height, Width, DepImg)
T = 130;   % 0~255 的中值
OriImg = double(OriImg);
DepImg = double(DepImg);
OriImg = OriImg - T;
C1 = 0.0001;
C2 = 0.000001;
%Ceta = 0.9;       %如何使得远处的强度衰减地更厉害一些？是否通过添加这个参数可以控制？
result = exp(-( C1*(OriImg.^2) + C2*(DepImg.^2) ));
%result = exp(-( C1*(Ceta*(OriImg.^2) + (1-Ceta)*(DepImg.^2))));

end