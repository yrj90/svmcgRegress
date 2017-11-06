function mse = CalcMSE(predLabel, gtLabel)
    if length(predLabel) ~= length(gtLabel)
       sprintf('The number of Samples is not equal to the No. in Ground truth!!') 
    else
        sample_No = length(predLabel);
    end
    for n = 1:sample_No
        diffsq(n) = (predLabel(n) - gtLabel(n))^2;
    end
    sq = sum(diffsq);
    mse = sq / numel(gtLabel);
end