function [rxsig] = MIMORx(gc,tp,W,x,angle)
        
    numTx= tp.numTXElements;
    ula = phased.ULA( tp.numTXElements, ...
        'ElementSpacing', 0.5*gc.lambda, ...
        'Element', phased.IsotropicAntennaElement,'Taper',W);
    collector = phased.Collector(...
     'Sensor',ula, ...
     'PropagationSpeed',gc.cLight,...
     'OperatingFrequency',gc.fc);
    receiver = phased.ReceiverPreamp( ...
     'Gain',tp.rxGain,'NoiseFigure',tp.noisefigure,'SampleRate' ,tp.f0,...
     'ReferenceTemperature',gc.nT);
%     figure;
%     plotResponse(ula,gc.fc,gc.cLight,'RespCut','Az','Format','Polar','Unit','dbi');
    rxsig = collector(x,angle);
    rxsig = receiver(rxsig);
    rxsig = sum(rxsig,2);
end