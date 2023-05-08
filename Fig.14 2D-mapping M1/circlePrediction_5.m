function [pFor, errorX, errorY,iPos, jPos,Thresh,noiseLevel] = circlePrediction_5(I,payload)
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

%EC estimation
EC = [];
n = 1;

errorX = errorX + 0.5;
errorY = errorY + 0.5;

for T = 0:1:max(noiseLevel)
    type1N = 0;
    type2N = 0;
    dis = 0;
for i=1:pFor
   if(noiseLevel(i) <= T)
  
   if(abs(errorX(i))==0.5 && abs(errorY(i))==0.5)
       type1N = type1N + 2;
       continue
  end
  
  if(abs(errorX(i))==1.5 && abs(errorY(i))==1.5)
       type2N = type2N + log2(3);
       continue
  end
   
   if(abs(errorX(i))==0.5 && abs(errorY(i))==1.5)
       type2N = type2N + log2(3);
       continue
   end
   
   if(abs(errorX(i))==1.5 && abs(errorY(i))==0.5)
       type2N = type2N + log2(3);
       continue
   end
   
   if(abs(errorX(i))==0.5)
       type2N = type2N + 1;
       continue
   end
   if(abs(errorY(i))==0.5)
       type2N = type2N + 1;
       continue
   end
   
   end
end

EC(n) = type1N + type2N;

if(EC(n) >= payload)
    break;
end
n = n+1;

end
Thresh = T;
end