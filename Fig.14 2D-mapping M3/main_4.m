clear all;
clc;

imgdir = dir('*.bmp');
fid=fopen('fileName.txt','wt');
performance = zeros(length(imgdir)*2,200);
location_map = zeros(length(imgdir),200);

for i = 1:6
I = double(imread([imgdir(i).name]));
fprintf(fid, '%s\n',imgdir(i).name);
nImg= 2*(i-1)+1;

% I = double(imread('Baboon.bmp'));
% nImage = 1;
tic
[nPer LM] = Manner1_4(I);
toc
performance(nImg,:) = nPer(1,:);
performance(nImg+1,:) = nPer(2,:);
location_map(nImg,:) = LM(:);
end
fclose(fid);

