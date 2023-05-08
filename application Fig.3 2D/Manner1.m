function [performance LM Iw] = Manner1(I,message)
[d1 d2] = size(I);
I_or = I;
n = 1;
performance = zeros(2,100);
deltaEC = 1000;
Tu = 8;

LM = zeros(1,100);



for payload = length(message)
    
    I = I_or;
    
    
    
    
    half = payload*0.5;
    [bin_LM bin_LM_len I] = LocationMap(I);
    [exbit] = extraBits_cross(I);
    half_cross = half+bin_LM_len+66+exbit;
    [pFor, crossX, crossY, crossIPos, crossJPos, T1, crossNL,stream23, c1, I] = crossPrediction(I, half_cross,bin_LM_len);
    len = sum(stream23 == 3);
    len3 = floor(len*log2(3));
    str = num2str(message(1:len3), '%0.0f');
    
    str3 = [];
    for i = 1:floor(length(str)/50)
        a = (i-1)*50 + 1;
        b = i*50;
        str_2 = ['1' str(a:b)];
        str_1 = bin2dec(str_2);
        str_1 = dec2base(str_1,3,33);
        str3 = [str3 str_1];
    end
    a = floor(length(str)/50)*50 + 1;
    b = length(str);
    if a < b
        str_2 = ['1' str(a:b)];
        str_1 = bin2dec(str_2);
        str_1 = dec2base(str_1,3);
        str3 = [str3 str_1];
    end
    
    str2 = [c1 bin_LM message(len3+1:half)];
    
    half_cross = floor(length(str2)+length(str3)*log2(3));
    
    [crossIw, nBit, MSE] = singleLayerEmbedding(I, half_cross, pFor, crossX, crossY, crossIPos, crossJPos,T1,crossNL,str2,str3);
    performance(1,n) = performance(1,n)  + nBit - bin_LM_len;
    LM(1,n) = LM(1,n) + bin_LM_len;
    
    % 2nd pass embedding
    [bin_LM bin_LM_len crossIw] = LocationMap_circle(crossIw);
    [exbit] = extraBits_circle(I);
    half_circle = half+bin_LM_len+66+exbit;
    [pFor, circleX, circleY, circleIPos, circleJPos, T2, circleNL,stream23, c1,crossIw] = circlePrediction(crossIw, half_circle,bin_LM_len);
    
    len = sum(stream23 == 3);
    len3 = floor(len*log2(3));
    str = num2str(message(half+1:half+len3), '%0.0f');
    
    str3 = [];
    for i = 1:floor(length(str)/50)
        a = (i-1)*50 + 1;
        b = i*50;
        
        str_2 = ['1' str(a:b)];
        str_1 = bin2dec(str_2);
        str_1 = dec2base(str_1,3,33);
        str3 = [str3 str_1];
        
    end
    a = floor(length(str)/50)*50 + 1;
    b = length(str);
    if a < b
        str_2 = ['1' str(a:b)];
        str_1 = bin2dec(str_2);
        str_1 = dec2base(str_1,3);
        str3 = [str3 str_1];
    end
    
    str2 = [c1 bin_LM message(half+len3+1:payload)];
    half_circle = floor(length(str2)+length(str3)*log2(3));
    
    [Iw,  nBit, MSE] =  single2Embedding(crossIw, half_circle, pFor, circleX, circleY, circleIPos, circleJPos,T2,circleNL,str2,str3);
    
    
    
    performance(1,n) = performance(1,n)  + nBit - bin_LM_len;
    LM(1,n) = LM(1,n) + bin_LM_len;
    if nBit < half_circle
        performance(1,n) = 0;
        break
    end
    dis = sum(sum(abs(I_or-Iw).^2));
    ps = 10*log10(255^2*d1*d2/dis);
    performance(2,n) = ps;
    
    %     if(n>=2)
    %         deltaEC = performance(1,n) - performance(1,n-1);
    %     end
    
    n = n + 1;
    
end


end