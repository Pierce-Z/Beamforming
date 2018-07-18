function [txsigx] = MIMOTx(gc,tp,W,x,angle)

    ula = phased.ULA( tp.numTXElements, ...
        'ElementSpacing', 0.5*gc.lambda, ...
        'Element', phased.IsotropicAntennaElement,'Taper',W);
%     steeringvec = phased.SteeringVector('SensorArray',ula,'PropagationSpeed',gc.cLight);
    
    transmitter = phased.Transmitter('PeakPower',tp.txPower,'Gain',tp.txGain);
    %Transmit array
    radiator = phased.Radiator('Sensor',ula,'WeightsInputPort',false,...
        'PropagationSpeed',gc.cLight,'OperatingFrequency',gc.fc,...
        'CombineRadiatedSignals',true);
%     figure;
%     plotResponse(ula,gc.fc,gc.cLight,'RespCut','Az','Format','Polar','Unit','dbi');
    txsigx = transmitter(x);    
    txsigx = radiator(txsigx,angle);
    
end