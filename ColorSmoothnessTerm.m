function output = ColorSmoothnessTerm(color,sigma)
%Calculate the smoothness term matrix of MRF model for a 3-channel color image
%Output: 
%   output      -   the output sparse matrix
%Input: 
%   color       -   Input color image
%   sigma       -   Coefficient of gaussian kernel for color similarity
%Code Author:
%   Liu Junyi, Zhejiang University
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
height = size(color,1);
width = size(color,2);
x=zeros(1,width * (height-1) * 2 + (width-1) * height * 2);
y=zeros(1,width * (height-1) * 2 + (width-1) * height * 2);
s=zeros(1,width * (height-1) * 2 + (width-1) * height * 2);
colorUp = [color;zeros(1,width,3)]; 
colorUp = colorUp(2:height+1,:,:);         % �����������ƶ�һ�У����һ����0���
colorLeft = [color,zeros(height,1,3)]; 
colorLeft = colorLeft(:,2:width+1,:);      % �����������ƶ�һ�У����һ����0���
CompareColor{1}=colorUp;
CompareColor{2}=colorLeft;

% ���Ա�Ե�����ؽ��в���
rowRange{1} = 1:height-1;       %  �������ӹ�ϵ������Ϊ width * (height-1)
colRange{1} = 1:width;
rowRange{2} = 1:height;         %  �������ӹ�ϵ������Ϊ (width-1) * height
colRange{2} = 1:width-1;
indexRange{1} = 1 : width * (height-1);
indexRange{2} = width * (height-1) + 1 : width * (height-1) + (width-1) * height;
nodeNumber{1} = width * (height-1);
nodeNumber{2} = (width-1) * height;
offset{1} = 1;                  %  �������ӹ�ϵ������ƫ��Ϊ1
offset{2} = height;             %  �������ӹ�ϵ������ƫ��Ϊheight

[mu,mv] = meshgrid(1:height, 1:width);
mu = mu';
mv = mv';
indexPtr = 0;
for i=1:2 % ����ķ����ͼ����в���
    % ���ָ��ͼ��Խ�������Smoothness��ļ���
    Temp1 = color(rowRange{i},colRange{i},:) - CompareColor{i}(rowRange{i},colRange{i},:);
    Temp2 = Temp1(:,:,1).^2+Temp1(:,:,2).^2+Temp1(:,:,3).^2;
    Temp3 = sqrt(exp(-1/(2*sigma^2)*Temp2));
    
    % ��һ����:ԭͼ
    indexRangePart = indexPtr + 1:indexPtr + nodeNumber{i};
    indexPtr = indexRangePart(end);
    xTemp = indexRange{i};
    x(indexRangePart) = xTemp;
    
    muTemp = mu(rowRange{i},colRange{i});
    mvTemp = mv(rowRange{i},colRange{i});
    pu = reshape(muTemp,length(rowRange{i})*length(colRange{i}),1);
    pv = reshape(mvTemp,length(rowRange{i})*length(colRange{i}),1);
    yTemp = pu + (pv - 1) * height;
    y(indexRangePart) = yTemp;

    sTemp = reshape(Temp3,numel(Temp3),1);
    s(indexRangePart) = sTemp;

    % �ڶ�����:�Ƚ�ͼ
    indexRangePart = indexPtr + 1:indexPtr + nodeNumber{i};
    indexPtr = indexRangePart(end);
    
    x(indexRangePart) = xTemp;

    y(indexRangePart) = yTemp + offset{i};

    s(indexRangePart) = -sTemp;
end
output=sparse(x,y,s,indexRange{2}(end),height*width);

