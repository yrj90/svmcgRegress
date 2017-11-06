function pcc = CalcPCC(predLabel, gtLabel)
    muY = mean(predLabel);
    muGt = mean(gtLabel);
    
    sdY = std(predLabel);
    sdGt = std(gtLabel);
    n = length(gtLabel);
    for i = 1:n
        tmpY = (predLabel(i) - muY) / sdY;
        tmpGt = (gtLabel(i) - muGt) / sdGt;
        product(i) = tmpY*tmpGt;
    end
    
    SUM = sum(product);
    pcc = SUM /(n-1);
end