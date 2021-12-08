clear all;
close all;
%{
for id = 0:94
    path = ['./result/um_hdetalimg' num2str(id) '.png'];
    A = imread(path);
    path = ['./result/um_heightimg' num2str(id) '.png'];
    B = imread(path);
    path = ['./result/um_heightdifimg' num2str(id) '.png'];
    C = imread(path);
    IMG = zeros(size(A,1),size(A,2),3);
    IMG(:,:,1) = A(:,:);
    IMG(:,:,2) = B(:,:);
    IMG(:,:,3) = C(:,:);
    IMG(:,:,:) = IMG(:,:,:) / 255;
  %  imshow(IMG);
    IMGGray = rgb2gray(IMG);
    BW1 = edge(IMGGray,'canny');
   % figure;
   % imshow(BW1);
    path = ['./result/um_newcolorimg' num2str(id) '.png'];
    imwrite(IMG, path);
    path = ['./result/um_edge' num2str(id) '.png'];
    imwrite(BW1, path);
    id
   % input('next','s');
end
%}
%{
for id = 0:94
    path = ['./data/KITTI_ROAD/um_hdetalimg' num2str(id) '.bmp'];
    A = imread(path);
    path = ['./data/KITTI_ROAD/um_heightimg' num2str(id) '.bmp'];
    B = imread(path);
    path = ['./data/KITTI_ROAD/um_heifidimg' num2str(id) '.bmp'];
    C = imread(path);
    IMG = zeros(size(A,1),size(A,2),3);
    IMG(:,:,1) = A(:,:);
    IMG(:,:,2) = B(:,:);
    IMG(:,:,3) = C(:,:);
    IMG(:,:,:) = IMG(:,:,:) / 255;
  %  imshow(IMG);
    IMGGray = rgb2gray(IMG);
  %  figure;
  %  imshow(IMGGray);
    BW1 = edge(IMGGray,'canny');
  %  figure;
  %  imshow(BW1);
    path = ['./result/um_colorpoints' num2str(id) '.bmp'];
    imwrite(IMG, path);
    path = ['./result/um_graypoints' num2str(id) '.bmp'];
    imwrite(IMGGray, path);
    id
 %   input('next','s');
end
%}

for id = 0:94
    path = ['./result/um_graypoints' num2str(id) '.png'];
    A = imread(path);
    figure(1);
    imshow(A);
    BW1 = edge(A,'canny');
    figure(2);
    imshow(BW1);
  %  path = ['./result/um_edge' num2str(id) '.png'];
  %  imwrite(BW1, path);
  %  id
    input('next','s');
end