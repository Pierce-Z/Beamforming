function [weight,z,w] = sig_compare(x,y,Wr1,Wr2,Wt1,Wt2)
%UNTITLED5 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    sigpow_x = abs(x);
    sigpow_y = abs(y);
    if sigpow_x >= sigpow_y
        weight = Wr1;
        z = x;
        w = Wt1;
    else
        weight = Wr2;
        z = y;
        w = Wt2;
    end
end

