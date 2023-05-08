function [Iw, nBit, MSE,str2,str3] = single2Extract(I,Payload, pFor, IX, IY, IXpos, IYpos, Thresh, noiseLevel,str2_len)
Iw = I;
str2 = [];
str3 = [];


dis = 0;
nBit = 0;

for iP=67:pFor
    %Is payload satisfied?
    if(nBit < Payload && noiseLevel(iP)<=Thresh)
    %embedding
    %|x| and |y| = 0.5
    if(abs(IY(iP))==0.5 && abs(IX(iP))==0.5)
        str3 = [str3 0];
        nBit = nBit+log2(3);
        continue
    elseif(abs(IY(iP))==0.5 && abs(IX(iP))==1.5)
        str3 = [str3 1];
        Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) - sign(IX(iP))*1;
        nBit = nBit+log2(3);
        continue
    elseif(abs(IY(iP))==1.5 && abs(IX(iP))==0.5)
        str3 = [str3 2];
        Iw(IXpos(iP)+1,IYpos(iP)-1) = I(IXpos(iP)+1,IYpos(iP)-1) - sign(IY(iP))*1;
        nBit = nBit+log2(3);
        continue
    end

    if length(str2) < str2_len
    %|x| and |y| = 1.5
    if(abs(IY(iP))==1.5 && abs(IX(iP))==1.5)
        str2 = [str2 0];
        nBit = nBit+1;
        continue
    elseif(abs(IY(iP))==2.5 && abs(IX(iP))==2.5)
        str2 = [str2 1];
        Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) - sign(IX(iP))*1;
        Iw(IXpos(iP)+1,IYpos(iP)-1) = I(IXpos(iP)+1,IYpos(iP)-1) - sign(IY(iP))*1;
        nBit = nBit+1;
        continue
    end
    
    %|y| = 0.5
    if(abs(IY(iP))==0.5)
        str2 = [str2 0];
        Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) - sign(IX(iP))*1;
        nBit = nBit+1;
        continue
    elseif(abs(IY(iP))==1.5)
        str2 = [str2 1];
        Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) - sign(IX(iP))*1;
        Iw(IXpos(iP)+1,IYpos(iP)-1) = I(IXpos(iP)+1,IYpos(iP)-1) - sign(IY(iP))*1;
        nBit = nBit+1;
        continue
    end
   %
   
    %|x| = 0.5
    if(abs(IX(iP))==0.5)
        str2 = [str2 0];
        Iw(IXpos(iP)+1,IYpos(iP)-1) = I(IXpos(iP)+1,IYpos(iP)-1) - sign(IY(iP))*1;
        nBit = nBit+1;
        continue
    elseif(abs(IX(iP))==1.5)
        str2 = [str2 1];
        Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) - sign(IX(iP))*1;
        Iw(IXpos(iP)+1,IYpos(iP)-1) = I(IXpos(iP)+1,IYpos(iP)-1) - sign(IY(iP))*1;
        nBit = nBit+1;
        continue
    end
    end
    dis = dis + 2;
    Iw(IXpos(iP),IYpos(iP)) = I(IXpos(iP),IYpos(iP)) - sign(IX(iP))*1;
    Iw(IXpos(iP)+1,IYpos(iP)-1) = I(IXpos(iP)+1,IYpos(iP)-1) - sign(IY(iP))*1;
    
    end
     %
end

MSE = sum(sum(abs(Iw-I)));
% ps = 10*log10(255^2*d1*d2/MSE);
  
end