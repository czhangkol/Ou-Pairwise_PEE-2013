clear all;
clc;

imgdir = dir('*.bmp');
fid=fopen('fileName.txt','wt');
performance = zeros(length(imgdir)*2,100);
location_map = zeros(length(imgdir),100);

for i = 1:1
I = double(imread([imgdir(i).name]));
fprintf(fid, '%s\n',imgdir(i).name);
nImg= 2*(i-1)+1;

% Input the binary message bit stream.
% The default message is set as the pseudorandom binary stream with a size of
% 10000 bits

message = mod(randperm(10000),2);

tic
[nPer LM Iw] = Manner1(I,message);
toc
performance(nImg,:) = nPer(1,:);
performance(nImg+1,:) = nPer(2,:);
location_map(nImg,:) = LM(:);

Iw = uint8(Iw);
imwrite(Iw,['marked_' imgdir(i).name],'bmp');




end
fclose(fid);



