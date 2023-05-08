function [pFor, errorX, errorY, iPos, jPos,Thresh,noiseLevel,Capacity, LM_len,str2_len] = crossPara(I)
[d1 d2] = size(I);

crossHis = zeros(511,511);
noiseLevel = zeros(1,64525);
iPos = zeros(1,65025);
jPos = zeros(1,65025);
errorX = zeros(1,65025);
errorY = zeros(1,65025);
pFor = 1;
his = zeros(1,511);
his2D = zeros(511,511);

%prediction
for i = 2:2:d1-2
   for j = 2:2:d2-2 
  ii = i+1;
  jj = j+1;
                           a = I(i-1,j);                     g = I(i-1,j+2); 

           b = I(i  ,j-1); x = I(i  ,j); d = I(i  ,j+1);

                           c = I(i+1,j); y = I(i+1,j+1); e = I(i+1,j+2);

          h = I(i+2,j-1);                  f = I(i+2,j+1);

    noiseLevel(pFor) = abs(a-b)+abs(b-c)+abs(c-d)+abs(d-a)+abs(c-f)+abs(f-e)+abs(e-d)+abs(d-g)+abs(c-h);                                        
%   noiseLevel(pFor) = abs(I(i-1,j)-I(i,j+1)) + abs(I(i,j+1)-I(i+1,j)) + abs(I(i+1,j)-I(i,j-1))  + abs(I(i,j-1)-I(i-1,j)) + ...
%        + abs(I(ii-1,jj)-I(ii,jj+1)) + abs(I(ii,jj+1)-I(ii+1,jj)) + abs(I(ii+1,jj) - I(ii,jj-1));
  errorX(pFor) = I(i,j) -  ceil( (I(i-1,j) + I(i,j-1) + I(i+1,j) + I(i,j+1))/4);
  errorY(pFor) =  I(ii,jj) - ceil( (I(ii-1,jj) + I(ii,jj-1) + I(ii+1,jj) + I(ii,jj+1))/4);
  crossHis(errorX(pFor)+256,errorY(pFor)+256) = crossHis(errorX(pFor)+256,errorY(pFor)+256) + 1;
  his(errorX(pFor)+256) = his(errorX(pFor)+256) + 1;
  his(errorY(pFor)+256) = his(errorY(pFor)+256) + 1;
  his2D(errorX(pFor)+256,errorY(pFor)+256) = his2D(errorX(pFor)+256,errorY(pFor)+256)+1;
  iPos(pFor) = i;
  jPos(pFor) = j;
  pFor = pFor + 1;
    end
end
pFor = pFor -1;
errorX = errorX + 0.5;
errorY = errorY + 0.5;

pixel = [];
for i = 1:66
    pixel = [pixel I(iPos(i),jPos(i))];
end
c1=LSB(pixel);
c1 = num2str(c1(1:66), '%0.0f');
Thresh = double(bin2dec(c1(1:12)));
LM_len = double(bin2dec(c1(13:30)));
Capacity = double(bin2dec(c1(31:48)));
str2_len = double(bin2dec(c1(49:66)));
end