function [Iw] = LSB_recover_circle(I,c1)
[d1 d2] = size(I);
circleHis = zeros(511,511);
noiseLevel = zeros(1,65025);
iPos = zeros(1,65025);
jPos = zeros(1,65025);
errorX = zeros(1,65025);
errorY = zeros(1,65025);
pFor = 1;
his = zeros(1,511);
his2D = zeros(511,511);


%prediction
for i = 2:2:d1-2
   for j = 3:2:d2-1 
             g = I(i-1,j-2);               a = I(i-1,j);

                             d = I(i,j-1); x = I(i  ,j); b = I(i  ,j+1);

             e = I(i+1,j-2); y = I(i+1,j-1); c = I(i+1,j);  

                             f = I(i+2,j-1);             h = I(i+2,j+1);
       ii = i+1;
       jj = j-1;
       noiseLevel(pFor) = abs(a-b)+abs(b-c)+abs(c-d)+abs(d-a)+abs(c-f)+abs(f-e)+abs(e-d)+abs(d-g)+abs(c-h);
       errorX(pFor) = I(i,j) - ceil( (I(i-1,j) + I(i,j-1) + I(i+1,j) + I(i,j+1))/4 );
       errorY(pFor) =  I(ii,jj) -  ceil( (I(ii-1,jj) + I(ii,jj-1) + I(ii+1,jj) + I(ii,jj+1))/4 );
       circleHis(errorX(pFor)+256,errorY(pFor)+256) = circleHis(errorX(pFor)+256,errorY(pFor)+256) + 1;
       his(errorX(pFor)+256) = his(errorX(pFor)+256) + 1;
       his(errorY(pFor)+256) = his(errorY(pFor)+256) + 1;
       his2D(errorX(pFor)+256,errorY(pFor)+256) = his2D(errorX(pFor)+256,errorY(pFor)+256)+1;
       iPos(pFor) = i;
       jPos(pFor) = j;
       pFor = pFor + 1;
    end
end
pFor = pFor -1;

pixel = [];
for i = 1:66
    pixel = [pixel I(iPos(i),jPos(i))];
end
pixel=LSB_Substitute(pixel,c1(1:66));
for i = 1:66
    I(iPos(i),jPos(i)) = pixel(i);
end

Iw = I;
end