function [ula] = plotpattern(gc,tp,weight)
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    ula = phased.ULA( tp.numTXElements, ...
        'ElementSpacing', 0.5*gc.lambda, ...
        'Element', phased.IsotropicAntennaElement,'Taper',weight);
    
end

