%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function Name: ADMatrix
%Aim: Calculate the N * N matrix (A) for anisotropic difffusion model
%Output: 
%   output      -   the output sparse matrix
%Input: 
%   color       -   Input color image
%   depth       -   Input sparse depth map
%   sigma       -   Coefficient of gaussian kernel for color similarity
%   data_weight -   weight of the measurements
%Code Author:
%   Liu Junyi, Zhejiang University
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = ADMatrix(color,depth,sigma,data_weight)
    height = size(color,1);  
    width = size(color,2);
    number = height * width;
    x = zeros(height * width * 5,1);    % x,y,s是干嘛的？
    y = zeros(height * width * 5,1);
    s = zeros(height * width * 5,1);
    count = 1;
    colorN3 = reshape(color,number,3);      % 将图像矩阵转换成了向量，每个元素是rgb颜色值
    for i = 1:height 
        for j = 1:width
            
            pos = height*(j-1)+i;
           
            temp = [pos - 1, pos + 1, pos - height, pos + height];  % 上下左右四个位置
            judge = zeros(4,1);     % 边界值判断
            judge(1) = mod(temp(1),height) ~= 0;    % 最左边
            judge(2) = mod(temp(2),height) ~= 1;    % 最右边
            judge(3) = temp(3) - height > 0;    % 最上边
            judge(4) = temp(4) + height < number;   % 最下边
            judge = logical(judge);     % 似乎是没有必要的操作，本身就是logical的
            validNumber = sum(judge);   % 有效的位置个数（上下左右四个方向，除去边界值）
            
            % 扩散公式，根据梯度计算扩散权重，梯度根据RGB空间计算
            w = exp(-1/(2*sigma^2)*sum(( repmat(colorN3(pos,:),validNumber,1) - colorN3(temp(judge),:)).^2,2)); 

            x(count:count+validNumber-1) = pos*ones(validNumber,1);     % 存放目标像素位置
            y(count:count+validNumber-1) = temp(judge);     %   存放目标像素的邻域位置（有效的）
            s(count:count+validNumber-1) = -w/sum(w);       % 存放权重（归一化过后，并且取了反，到时候不用减了）
            count = count + validNumber;
            x(count) = pos;     % 当前位置
            y(count) = pos;     % 当前位置
            if depth(i,j)==0
                s(count) = 1;   
            else
                s(count) = data_weight + 1;
            end
            count = count + 1;
        end
    end
    x = x(1:count-1);
    y = y(1:count-1);
    s = s(1:count-1);
    output = sparse(x,y,s,number,number);   % 生成了一个稀疏矩阵
end
