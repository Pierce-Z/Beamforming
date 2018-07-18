function W = c_codebk(M,K)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
for m = 1:M
    for k = 1:K
%         W(m,k) = j^(floor((m-1) * mod(((k-1) + K/4) , K) / K * 4));
        W(m,k) = j^(((m-1) * (k-1) - K/2 ) / K * 4);
    end
end
end

