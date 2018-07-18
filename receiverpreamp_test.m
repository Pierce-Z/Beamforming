hr = phased.ReceiverPreamp('Gain',20,...
    'NoiseFigure',5,'ReferenceTemperature',300,...
    'SampleRate',28e9,'SeedSource','Property','Seed',1e3);
t = unigrid(0,0.001,0.1,'[)');
x = exp(1j*2*pi*100*t);
y = hr(x);
NB = hr.SampleRate;
noisepow = physconst('Boltzman')*...
    systemp(hr.NoiseFigure,hr.ReferenceTemperature)*NB;
rng(1e3);
y1 = 10 * x + sqrt(noisepow/2)*(randn(size(x))+1j * randn(size(x)));

y_noise = sqrt(noisepow/2)*(randn(size(x))+1j * randn(size(x)));