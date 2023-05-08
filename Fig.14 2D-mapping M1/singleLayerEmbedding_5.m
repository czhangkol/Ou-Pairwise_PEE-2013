function [Iw, nBit, MSE] = singleLayerEmbedding_5(I,Payload, pFor, IX, IY, IXpos, IYpos,Thresh, noiseLevel)
Iw = I;

data = randperm(512^2);
dis = 0;
nBit = 0;
nData = 1;
for iP=1:pFor
    %Is payload satisfied?
    if(nBit < Payload && noiseLevel(iP)<=Thresh)
    %embedding
    %|x| and |y| = 0.5
    if(abs(IY(iP))==0.5 && abs(IX(iP))==0.5)
        bit = mod(data(iP),2);
        nData = nData + 1;
        nBit = nBit+2;
%         dis = dis + 2/3;
        if(bit ==1)
            Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) + sign(IX(iP))*1;
        end
        bit = mod(data(iP+256*512),2);
        if(bit ==1)
            Iw(IXpos(iP)+1,IYpos(iP)+1) = I(IXpos(iP)+1,IYpos(iP)+1) + sign(IY(iP))*1;
        end
        continue
    end
    
    %|x| and |y| = 1.5
    if(abs(IY(iP))==1.5 && abs(IX(iP))==1.5)
        bit = mod(data(fix(iP/255)*500+mod(iP,255)),3);
        nData = nData + 1;
        nBit = nBit+log2(3);
        dis = dis + 1;
        if(bit ==1)
            Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) + sign(IX(iP))*1;
            Iw(IXpos(iP)+1,IYpos(iP)+1) = I(IXpos(iP)+1,IYpos(iP)+1) + sign(IY(iP))*1;
        elseif(bit ==2)
            Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) + sign(IX(iP))*1;
            Iw(IXpos(iP)+1,IYpos(iP)+1) = I(IXpos(iP)+1,IYpos(iP)+1) + sign(IY(iP))*2;
        else
            Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) + sign(IX(iP))*2;
            Iw(IXpos(iP)+1,IYpos(iP)+1) = I(IXpos(iP)+1,IYpos(iP)+1) + sign(IY(iP))*1;
        end
        continue
    end
    
    %|x| = 0.5, |y| = 1.5
    if(abs(IY(iP))==1.5 && abs(IX(iP))==0.5)
        bit = mod(data(fix(iP/255)*500+mod(iP,255)),3);
        nData = nData + 1;
        nBit = nBit+log2(3);
%         dis = dis + 7/3;
        if(bit ==0)
            Iw(IXpos(iP)+1,IYpos(iP)+1) = I(IXpos(iP)+1,IYpos(iP)+1) + sign(IY(iP))*1;
        elseif (bit == 1)
            Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) + sign(IX(iP))*1;
            Iw(IXpos(iP)+1,IYpos(iP)+1) = I(IXpos(iP)+1,IYpos(iP)+1) + sign(IY(iP))*1;
        else
            Iw(IXpos(iP)+1,IYpos(iP)+1) = I(IXpos(iP)+1,IYpos(iP)+1) + sign(IY(iP))*2;
        end
        continue
    end
    
    %|x| = 1.5, |y| = 0.5
    if(abs(IY(iP))==0.5 && abs(IX(iP))==1.5)
        bit = mod(data(fix(iP/255)*500+mod(iP,255)),3);
        nData = nData + 1;
        nBit = nBit+log2(3);
%         dis = dis + 7/3;
        if(bit ==0)
            Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) + sign(IX(iP))*1;
        elseif (bit == 1)
            Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) + sign(IX(iP))*1;
            Iw(IXpos(iP)+1,IYpos(iP)+1) = I(IXpos(iP)+1,IYpos(iP)+1) + sign(IY(iP))*1;
        else
            Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) + sign(IX(iP))*2;
        end
        continue
    end
    
    %|y| = 0.5
    if(abs(IY(iP))==0.5)
        bit = mod(data(fix(iP/255)*500+mod(iP,255)),2);
        nData = nData + 1;
        nBit = nBit+1;
        dis = dis + 3;
        if(bit == 0)
            Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) + sign(IX(iP))*1;
            Iw(IXpos(iP)+1,IYpos(iP)+1) = I(IXpos(iP)+1,IYpos(iP)+1) + sign(IY(iP))*1;
        elseif(bit ==1)
            Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) + sign(IX(iP))*2;
        end
        continue
    end
   %
   
   
    %|x| = 0.5
    if(abs(IX(iP))==0.5)
        bit = mod(data(fix(iP/255)*500+mod(iP,255)),2);
        nData = nData + 1;
        nBit = nBit+1;
        dis = dis + 3;
        if(bit == 0)
            Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) + sign(IX(iP))*1;
            Iw(IXpos(iP)+1,IYpos(iP)+1) = I(IXpos(iP)+1,IYpos(iP)+1) + sign(IY(iP))*1;
        elseif(bit ==1)
            Iw(IXpos(iP)+1,IYpos(iP)+1) = I(IXpos(iP)+1,IYpos(iP)+1) + sign(IY(iP))*2;
        end
        continue
    end
    
   %|y| = 1.5
     if(abs(IY(iP))==1.5)
         Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) + sign(IX(iP))*2;
         Iw(IXpos(iP)+1,IYpos(iP)+1) = I(IXpos(iP)+1,IYpos(iP)+1) + sign(IY(iP))*1;
         continue
     end
   %
   
   %|x| = 1.5
   if(abs(IX(iP))==1.5)
       Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) + sign(IX(iP))*1;
       Iw(IXpos(iP)+1,IYpos(iP)+1) = I(IXpos(iP)+1,IYpos(iP)+1) + sign(IY(iP))*2;
       continue
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