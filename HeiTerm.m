function [result] = HeiTerm(OriImg, Height, Width, DepImg)
T = 130;   % 0~255 ����ֵ
OriImg = double(OriImg);
DepImg = double(DepImg);
OriImg = OriImg - T;
C1 = 0.0001;
C2 = 0.000001;
%Ceta = 0.9;       %���ʹ��Զ����ǿ��˥���ظ�����һЩ���Ƿ�ͨ���������������Կ��ƣ�
result = exp(-( C1*(OriImg.^2) + C2*(DepImg.^2) ));
%result = exp(-( C1*(Ceta*(OriImg.^2) + (1-Ceta)*(DepImg.^2))));

end