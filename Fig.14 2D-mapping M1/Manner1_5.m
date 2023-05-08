function [performance LM] = Manner1_5(I)
[d1 d2] = size(I);
I_or = I;
n = 1;
performance = zeros(2,200);
deltaEC = 1000;
Tu = 8;

LM = zeros(1,200);



for payload = [5000:1000:150000]
    
    I = I_or;

    half = payload*0.5;
    [bin_LM bin_LM_len I] = LocationMap(I);
    half_cross = half+bin_LM_len;
    [pFor, crossX, crossY, crossIPos, crossJPos, T1, crossNL] = crossPrediction_5(I, half_cross);
   
    [crossIw, nBit, MSE] = singleLayerEmbedding_5(I, half_cross, pFor, crossX, crossY, crossIPos, crossJPos,T1,crossNL);
    performance(1,n) = performance(1,n)  + nBit - bin_LM_len;
    LM(1,n) = LM(1,n) + bin_LM_len;
    
    [bin_LM bin_LM_len crossIw] = LocationMap_circle(crossIw);
    half_circle = half+bin_LM_len;
    [pFor, circleX, circleY, circleIPos, circleJPos, T2, circleNL] = circlePrediction_5(crossIw, half_circle);
    
    [Iw,  nBit, MSE] =  single2Embedding_5(crossIw, half_circle, pFor, circleX, circleY, circleIPos, circleJPos,T2,circleNL);
    performance(1,n) = performance(1,n)  + nBit - bin_LM_len;
    LM(1,n) = LM(1,n) + bin_LM_len;
    if nBit < half_circle
    performance(1,n) =  0;
    break
    end
    dis = sum(sum(abs(I_or-Iw).^2));
    ps = 10*log10(255^2*d1*d2/dis);
    performance(2,n) = ps;
    
    
    n = n + 1;

end
end