function [pFor, errorX, errorY, iPos, jPos,Thresh,noiseLevel,stream23,c1,I] = crossPrediction(I,payload,bin_LM_len)
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

%EC estimation
EC = [];
n = 1;
distortion = [];
errorX = errorX + 0.5;
errorY = errorY + 0.5;


for T = 0:1:max(noiseLevel)
    type1N = 0;
    type2N = 0;
    typeShift = 0;
    stream23 = [];
    for i=67:pFor
        if(noiseLevel(i) <= T)
            
            if(abs(errorX(i))==0.5 && abs(errorY(i))==0.5)
                type1N = type1N + log2(3);
                stream23 = [stream23 3];
                continue
            end
            
            if(abs(errorX(i))==1.5 && abs(errorY(i))==1.5)
                type2N = type2N + 1;
                stream23 = [stream23 2];
                continue
            end
            
            if(abs(errorX(i))==0.5)
                type2N = type2N + 1;
                stream23 = [stream23 2];
                continue
            end
            if(abs(errorY(i))==0.5)
                type2N = type2N + 1;
                stream23 = [stream23 2];
                continue
            end
            
            typeShift =  typeShift + 1;
            
            
            
        end
        
        if(type1N + type2N >= payload)
            break;
        end
        
        
        
        
    end
    EC(n) = type1N + type2N;
    if(EC(n) >= payload)
        break;
    end
    n = n+1;
    
end
Thresh = T;

b1=decimal2binary_minus(Thresh,12);
b2=decimal2binary_minus(bin_LM_len,18);
b1=[b1 b2];
pixel = [];
for i = 1:66
    pixel = [pixel I(iPos(i),jPos(i))];
end
c1=LSB(pixel);
pixel=LSB_Substitute(pixel(1:30),b1);
for i = 1:30
    I(iPos(i),jPos(i)) = pixel(i);
end

end