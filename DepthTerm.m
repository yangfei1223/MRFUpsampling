function [result] = DepthTerm(OriImg, Height, Width)

OriImg = double(OriImg);
C1 = 0.01;
result = exp(-C1*OriImg);


end

