function output = ColorSmoothnessN_N(color,sigma)
%Calculate the N * N smoothness term matrix of a 3-channel color image
%Output: 
%   output      -   the output sparse matrix
%Input: 
%   color       -   Input color image
%   sigma       -   Coefficient of gaussian kernel for color similarity
%Code Author:
%   Liu Junyi, Zhejiang University
%   Mar. 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
height = size(color,1);
width = size(color,2);
color = double(color);
% Ϊx,y,z��ǰ����ռ�,����Ϊ���ӹ�ϵ������,�����������ٶ�,
x=zeros(1,width * (height-1) + (width-1) * height);
y=zeros(1,width * (height-1) + (width-1) * height);
s=zeros(1,width * (height-1) + (width-1) * height);
colorUp = [color;zeros(1,width,3)]; 
colorUp = colorUp(2:height+1,:,:);         % �����������ƶ�һ�У����һ����0���
colorLeft = [color,zeros(height,1,3)]; 
colorLeft = colorLeft(:,2:width+1,:);      % �����������ƶ�һ�У����һ����0����
CompareColor{1}=colorUp;
CompareColor{2}=colorLeft;

rowRange{1} = 1:height-1;       %  �������ӹ�ϵ������Ϊ width * (height-1)
colRange{1} = 1:width;
rowRange{2} = 1:height;         %  �������ӹ�ϵ������Ϊ (width-1) * height
colRange{2} = 1:width-1;
indexRange{1} = 1 : width * (height-1);
indexRange{2} = width * (height-1) + 1 : width * (height-1) + (width-1) * height;
offset{1} = 1;                  %  �������ӹ�ϵ������ƫ��Ϊ1
offset{2} = height;             %  �������ӹ�ϵ������ƫ��Ϊheight

[mu,mv] = meshgrid(1:height, 1:width);
mu = mu';
mv = mv';
for i=1:2 % ����ķ����ͼ����в���
    % ���ָ��ͼ��Խ�������Smoothness��ļ���
    Temp1 = color(rowRange{i},colRange{i},:) - CompareColor{i}(rowRange{i},colRange{i},:);
    Temp2 = Temp1(:,:,1).^2+Temp1(:,:,2).^2+Temp1(:,:,3).^2;
    Temp3 = sqrt(exp(-1/(2*sigma^2)*Temp2));
    
    % ������е�λ��
    muTemp = mu(rowRange{i},colRange{i});
    mvTemp = mv(rowRange{i},colRange{i});
    pu = reshape(muTemp,length(rowRange{i})*length(colRange{i}),1);
    pv = reshape(mvTemp,length(rowRange{i})*length(colRange{i}),1);
    xTemp = pu + (pv - 1) * height;
    x(indexRange{i}) = xTemp;
    
    % ͨ���е�λ�ü�����е�λ��
    y(indexRange{i}) = xTemp + offset{i};
    
    % ��ɫ�����ƶ�
    sTemp = reshape(Temp3,numel(Temp3),1);
    s(indexRange{i}) = sTemp;
    
end
upDiag = sparse(x,y,s,height*width,height*width);
output = upDiag' + upDiag;  % �ڴ˲�û�н��Խ����ϵ�Ԫ����Ϊ1

