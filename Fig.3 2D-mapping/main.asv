clear all;
clc;

imgdir = dir('*.bmp');
fid=fopen('fileName.txt','wt');
performance = zeros(length(imgdir)*2,100);
location_map = zeros(length(imgdir),100);

for i = 1:length(imgdir)
I = double(imread([imgdir(i).name]));
fprintf(fid, '%s\n',imgdir(i).name);
nImg= 2*(i-1)+1;

tic
[nPer LM] = Manner1(I);
toc
performance(nImg,:) = nPer(1,:);
performance(nImg+1,:) = nPer(2,:);
location_map(nImg,:) = LM(:);
end
fclose(fid);



