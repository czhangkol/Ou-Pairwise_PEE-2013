function [Iw, nBit, MSE] = singleLayerEmbedding(I,Payload, pFor, IX, IY, IXpos, IYpos,Thresh, noiseLevel,str2,str3)
Iw = I;

b1=decimal2binary_minus(Payload,18);
b2=decimal2binary_minus(length(str2),18);
b1 = [b1 b2];

pixel = [];
for i = 31:66
    pixel = [pixel I(IXpos(i),IYpos(i))];
end
pixel=LSB_Substitute(pixel,b1);
for i = 31:66
    Iw(IXpos(i),IYpos(i)) = pixel(i-30);
end

data = randperm(512^2);
dis = 0;
nBit = 0;
nData = 1;
nData3 = 1;
for iP=67:pFor
    
    
    %Is payload satisfied?
    if(nBit < Payload && noiseLevel(iP)<=Thresh)
%         if nData3 == length(str3)
%             a = 1;
%         end
    %embedding
    %|x| and |y| = 0.5
    if(abs(IY(iP))==0.5 && abs(IX(iP))==0.5)
        bit = str3(nData3);
        nData3 = nData3 + 1;
        nBit = nBit+log2(3);
        dis = dis + 2/3;
        if(bit == '1')
            Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) + sign(IX(iP))*1;
        elseif(bit == '2' )
            Iw(IXpos(iP)+1,IYpos(iP)+1) = I(IXpos(iP)+1,IYpos(iP)+1) + sign(IY(iP))*1;
        end
        continue
    end
    
    if nData <= length(str2)
    %|x| and |y| = 1.5
    if(abs(IY(iP))==1.5 && abs(IX(iP))==1.5)
        bit = str2(nData);
        nData = nData + 1;
        nBit = nBit+1;
        dis = dis + 1;
        if(bit ==1)
            Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) + sign(IX(iP))*1;
            Iw(IXpos(iP)+1,IYpos(iP)+1) = I(IXpos(iP)+1,IYpos(iP)+1) + sign(IY(iP))*1;
        end
        continue
    end
    
    %|y| = 0.5
    if(abs(IY(iP))==0.5)
        bit = str2(nData);
        nData = nData + 1;
        nBit = nBit+1;
        dis = dis + 3/2;
        if(bit == 0)
            Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) + sign(IX(iP))*1;            
        elseif(bit ==1)
            Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) + sign(IX(iP))*1;
            Iw(IXpos(iP)+1,IYpos(iP)+1) = I(IXpos(iP)+1,IYpos(iP)+1) + sign(IY(iP))*1;
        end
        continue
    end
   %
   
    %|x| = 0.5
    if(abs(IX(iP))==0.5)
        bit = str2(nData);
        nData = nData + 1;
        nBit = nBit+1;
        dis = dis + 3/2;
        if(bit == 0)
            Iw(IXpos(iP)+1,IYpos(iP)+1) = I(IXpos(iP)+1,IYpos(iP)+1) + sign(IY(iP))*1;
        elseif(bit ==1)
            Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) + sign(IX(iP))*1;
            Iw(IXpos(iP)+1,IYpos(iP)+1) = I(IXpos(iP)+1,IYpos(iP)+1) + sign(IY(iP))*1;
        end
        continue
    end
    
    end
   
    dis = dis + 2;
    Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) + sign(IX(iP))*1;
    Iw(IXpos(iP)+1,IYpos(iP)+1) = I(IXpos(iP)+1,IYpos(iP)+1) + sign(IY(iP))*1;
    
    end
    
     %
end

MSE = sum(sum(abs(Iw-I)));
% ps = 10*log10(255^2*d1*d2/MSE);

  
end