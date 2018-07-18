function [W_1,W_2] = codebk_select(W,N)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
W1 =[1 0 0 0 1 0 0 0 ;1 0 0 0 -1 0 0 0].';
W2 =[1 0 1 0 1 0 1 0 ;1 0 -1 0 1 0 -1 0;1  0  -j  0  -1  0 j  0;1  0 j  0  -1  0  -j  0].';
W3 = -1 * c_codebk(8,8);  
switch N
    case 2
        if sum(W == W1(:,1)) == 8
            W_1 = W2(:,1);
            W_2 = W2(:,2);
        elseif sum(W == W1(:,2)) == 8
            W_1 = W2(:,3);
            W_2 = W2(:,4);
        end
    case 3
        if sum(W == W2(:,1)) == 8
            W_1 = W3(:,1);
            W_2 = W3(:,5);
        elseif sum(W == W2(:,2)) == 8
            W_1 = W3(:,3);
            W_2 = W3(:,7);
        elseif sum(W == W2(:,3)) == 8
            W_1 = W3(:,4);
            W_2 = W3(:,8);
        elseif sum(W == W2(:,4)) == 8
            W_1 = W3(:,2);
            W_2 = W3(:,6);
        end
end
    
    
   
%     W(1,:,:) = W1;
%     W(2,:,:) = W2;
%     W(3,:,:) = W3;

end

