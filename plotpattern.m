function [ula] = plotpattern(gc,tp,weight)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
    ula = phased.ULA( tp.numTXElements, ...
        'ElementSpacing', 0.5*gc.lambda, ...
        'Element', phased.IsotropicAntennaElement,'Taper',weight);
    
end

