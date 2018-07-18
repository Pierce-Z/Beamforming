function [weight,z,w] = sig_compare(x,y,Wr1,Wr2,Wt1,Wt2)
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明
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

