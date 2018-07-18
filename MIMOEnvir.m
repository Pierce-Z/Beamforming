function [sigLoss] = MIMOEnvir(x,pos_r,gc,SNR)
%Freespace attenuation
    spLoss = fspl(norm(pos_r,2),gc.lambda);
    sigLoss = x/sqrt(db2pow(spLoss(1)));
    sigLoss = awgn(sigLoss,SNR,'measured');
end

