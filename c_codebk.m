function W = c_codebk(M,K)
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
for m = 1:M
    for k = 1:K
%         W(m,k) = j^(floor((m-1) * mod(((k-1) + K/4) , K) / K * 4));
        W(m,k) = j^(((m-1) * (k-1) - K/2 ) / K * 4);
    end
end
end

