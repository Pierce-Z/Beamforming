clc;
clear all;
close all;
%% Parameters
% Fixed parameters
fp.cLight = 3e8;
fp.fc = 28e9;   % 28 GHz  Band
fp.lambda = fp.cLight/fp.fc;
fp.nT = 290; 
fp.scanAz = -180:180;

% Tunable parameters
tp.txPower = 5000;           % watt
tp.txGain = 20;           % dB
tp.noisefigure = 10;
tp.f0 = 28e9; %sample rate = noisewidth
tp.numTXElements = 8;       

tp.N_sgnl = 1000;
numTx= tp.numTXElements;

tp.rxGain = tp.txGain; % dB


SNR = 100;
Dev2toDev1 = [20; 0];
Dev1toDev2 = [-160; 0];
% Dev2toDev1 = - Dev2toDev1;
% Dev1toDev2 = - Dev1toDev2;
pos_r =  [10;0;0];
% signal formation
txsig = (randi(2 , tp.N_sgnl , 1) * 2 - 3)  + j * (randi(2 , tp.N_sgnl , 1) * 2 - 3);
%% First Signal Transmission 

% W_1 = codebk_select(**);
W_1 = [1 0 0 0 1 0 0 0 ];
% W_2 = codebk_select(**);
W_2 = [1 0 0 0 -1 0 0 0 ];
%Dev1  first training
txomni_1 = MIMOTx(fp,tp,W_1,txsig,Dev2toDev1);% configure the system's transmitter. 
sigLoss = MIMOEnvir(txomni_1,pos_r,fp,SNR);
rxomni_1 = MIMORx(fp,tp,W_1,sigLoss,Dev1toDev2);
rxomni_2 = MIMORx(fp,tp,W_2,sigLoss,Dev1toDev2);
%Dev1 second training
txomni_2 = MIMOTx(fp,tp,W_2,txsig,Dev2toDev1);% configure the system's receiver. 
sigLoss = MIMOEnvir(txomni_2,pos_r,fp,SNR);
rxomni_3 = MIMORx(fp,tp,W_1,sigLoss,Dev1toDev2);
rxomni_4 = MIMORx(fp,tp,W_2,sigLoss,Dev1toDev2);
%Dev2 first training
txomni_3 = MIMOTx(fp,tp,W_1,txsig,Dev1toDev2);% configure the system's transmitter. 
sigLoss = MIMOEnvir(txomni_3,pos_r,fp,SNR);
rxomni_5 = MIMORx(fp,tp,W_1,sigLoss,Dev2toDev1);
rxomni_6 = MIMORx(fp,tp,W_2,sigLoss,Dev2toDev1);
%Dev2 second training
txomni_4 = MIMOTx(fp,tp,W_2,txsig,Dev1toDev2);% configure the system's transmitter. 
sigLoss = MIMOEnvir(txomni_4,pos_r,fp,SNR);
rxomni_7 = MIMORx(fp,tp,W_1,sigLoss,Dev2toDev1);
rxomni_8 = MIMORx(fp,tp,W_2,sigLoss,Dev2toDev1);
%tx_Dev1 and rx_Dev2  
[Wr1,z1] = sig_compare(rxomni_1,rxomni_2,W_1,W_2,W_1,W_1);
[Wr2,z2] = sig_compare(rxomni_3,rxomni_4,W_1,W_2,W_2,W_2);
[Wr_next2,x,Wt_next1] = sig_compare(z1,z2,Wr1,Wr2,W_1,W_2);

ula1 = plotpattern(fp,tp,Wt_next1.');

ula2 = plotpattern(fp,tp,Wr_next2.');

%tx_Dev2 and rx_Dev1
[Wr1,z1] = sig_compare(rxomni_5,rxomni_6,W_1,W_2,W_1,W_1);
[Wr2,z2] = sig_compare(rxomni_7,rxomni_8,W_1,W_2,W_2,W_2);
[Wr_next1,x,Wt_next2] = sig_compare(z1,z2,Wr1,Wr2,W_1,W_2);
ula3 = plotpattern(fp,tp,Wt_next2.');
ula4 = plotpattern(fp,tp,Wr_next1.');
figure;
subplot(221)
    plotResponse(ula1,fp.fc,fp.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',-90:90);
    title('Dev1-txomni');
subplot(222)
    plotResponse(ula2,fp.fc,fp.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',union(-180:-90,90:180));
    title('Dev2-rxomni');
subplot(224)
    plotResponse(ula3,fp.fc,fp.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',union(-180:-90,90:180));
    title('Dev2-txomni');
subplot(223)
    plotResponse(ula4,fp.fc,fp.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',-90:90);
    title('Dev1-rxomni');
%% First feedback and mapping

[Wt_sec1,Wt_sec2] = codebk_select(Wt_next1.',2);%tx_Dev1
[Wr_sec1,Wr_sec2] = codebk_select(Wr_next1.',2);%rx_Dev1
[Wt_sec3,Wt_sec4] = codebk_select(Wt_next2.',2);%tx_Dev2
[Wr_sec3,Wr_sec4] = codebk_select(Wr_next2.',2);%rx_Dev2
%% Second Signal Transmission
%tx  first training
txsec_1 = MIMOTx(fp,tp,Wt_sec1.',txsig,Dev2toDev1);% configure the system's transmitter. 
sigLoss = MIMOEnvir(txsec_1,pos_r,fp,SNR);
rxsec_1 = MIMORx(fp,tp,Wr_sec3.',sigLoss,Dev1toDev2);
rxsec_2 = MIMORx(fp,tp,Wr_sec4.',sigLoss,Dev1toDev2);

%tx second training
txsec_2 = MIMOTx(fp,tp,Wt_sec2.',txsig,Dev2toDev1);% configure the system's receiver. 
sigLoss = MIMOEnvir(txsec_2,pos_r,fp,SNR);
rxsec_3 = MIMORx(fp,tp,Wr_sec3.',sigLoss,Dev1toDev2);
rxsec_4 = MIMORx(fp,tp,Wr_sec4.',sigLoss,Dev1toDev2);
%rx first training
txsec_3 = MIMOTx(fp,tp,Wt_sec3.',txsig,Dev1toDev2);% configure the system's transmitter. 
sigLoss = MIMOEnvir(txsec_3,pos_r,fp,SNR);
rxsec_5 = MIMORx(fp,tp,Wr_sec1.',sigLoss,Dev2toDev1);
rxsec_6 = MIMORx(fp,tp,Wr_sec2.',sigLoss,Dev2toDev1);
%rx second training
txsec_4 = MIMOTx(fp,tp,Wt_sec4.',txsig,Dev1toDev2);% configure the system's transmitter. 
sigLoss = MIMOEnvir(txsec_4,pos_r,fp,SNR);
rxsec_7 = MIMORx(fp,tp,Wr_sec1.',sigLoss,Dev2toDev1);
rxsec_8 = MIMORx(fp,tp,Wr_sec2.',sigLoss,Dev2toDev1);
%tx_Dev1 and rx_Dev2  
[Wr1,z1,Wt1] = sig_compare(rxsec_1,rxsec_2,Wr_sec3,Wr_sec4,Wt_sec1,Wt_sec1);
[Wr2,z2,Wt2] = sig_compare(rxsec_3,rxsec_4,Wr_sec3,Wr_sec4,Wt_sec2,Wt_sec2);
[Wr_next4,x,Wt_next3] = sig_compare(z1,z2,Wr1,Wr2,Wt1,Wt2);

ula1 = plotpattern(fp,tp,Wt_next3.');

ula2 = plotpattern(fp,tp,Wr_next4.');
%tx_Dev2 and rx_Dev1
[Wr1,z1,Wt1] = sig_compare(rxsec_5,rxsec_6,Wr_sec1,Wr_sec2,Wt_sec3,Wt_sec3);
[Wr2,z2,Wt2] = sig_compare(rxsec_7,rxsec_8,Wr_sec1,Wr_sec2,Wt_sec4,Wt_sec4);
[Wr_next3,x,Wt_next4] = sig_compare(z1,z2,Wr1,Wr2,Wt1,Wt2);
ula3 = plotpattern(fp,tp,Wt_next4.');
ula4 = plotpattern(fp,tp,Wr_next3.');
figure;
subplot(221)
    plotResponse(ula1,fp.fc,fp.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',-90:90);
    title('Dev1-txsec');
subplot(222)
    plotResponse(ula2,fp.fc,fp.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',union(-180:-90,90:180));
    title('Dev2-rxsec');
subplot(224)
    plotResponse(ula3,fp.fc,fp.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',union(-180:-90,90:180));
    title('Dev2-txsec');
subplot(223)
    plotResponse(ula4,fp.fc,fp.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',-90:90);
    title('Dev1-rxsec');
%% Second feedback and mapping
[Wt_beam1,Wt_beam2] = codebk_select(Wt_next3,3);%tx_Dev1
[Wr_beam1,Wr_beam2] = codebk_select(Wr_next3,3);%rx_Dev1
[Wt_beam3,Wt_beam4] = codebk_select(Wt_next4,3);%tx_Dev2
[Wr_beam3,Wr_beam4] = codebk_select(Wr_next4,3);%rx_Dev2
%% Third Signal Transmission
%tx  first training
txbeam_1 = MIMOTx(fp,tp,Wt_beam1.',txsig,Dev2toDev1);% configure the system's transmitter. 
sigLoss = MIMOEnvir(txbeam_1,pos_r,fp,SNR);
rxbeam_1 = MIMORx(fp,tp,Wr_beam3.',sigLoss,Dev1toDev2);
rxbeam_2 = MIMORx(fp,tp,Wr_beam4.',sigLoss,Dev1toDev2);

%tx second training
txbeam_2 = MIMOTx(fp,tp,Wt_beam2.',txsig,Dev2toDev1);% configure the system's receiver. 
sigLoss = MIMOEnvir(txbeam_2,pos_r,fp,SNR);
rxbeam_3 = MIMORx(fp,tp,Wr_beam3.',sigLoss,Dev1toDev2);
rxbeam_4 = MIMORx(fp,tp,Wr_beam4.',sigLoss,Dev1toDev2);
%rx first training
txbeam_3 = MIMOTx(fp,tp,Wt_beam3.',txsig,Dev1toDev2);% configure the system's transmitter. 
sigLoss = MIMOEnvir(txbeam_3,pos_r,fp,SNR);
rxbeam_5 = MIMORx(fp,tp,Wr_beam1.',sigLoss,Dev2toDev1);
rxbeam_6 = MIMORx(fp,tp,Wr_beam2.',sigLoss,Dev2toDev1);
%rx second training
txbeam_4 = MIMOTx(fp,tp,Wt_beam4.',txsig,Dev1toDev2);% configure the system's transmitter. 
sigLoss = MIMOEnvir(txbeam_4,pos_r,fp,SNR);
rxbeam_7 = MIMORx(fp,tp,Wr_beam1.',sigLoss,Dev2toDev1);
rxbeam_8 = MIMORx(fp,tp,Wr_beam2.',sigLoss,Dev2toDev1);
%tx_Dev1 and rx_Dev2  
[Wr1,z1,Wt1] = sig_compare(rxbeam_1,rxbeam_2,Wr_beam3,Wr_beam4,Wt_beam1,Wt_beam1);
[Wr2,z2,Wt2] = sig_compare(rxbeam_3,rxbeam_4,Wr_beam3,Wr_beam4,Wt_beam2,Wt_beam2);
[Wr_next6,x,Wt_next5] = sig_compare(z1,z2,Wr1,Wr2,Wt1,Wt2);
ula1 = plotpattern(fp,tp,Wt_next5.');
ula2 = plotpattern(fp,tp,Wr_next6.');
%tx_Dev2 and rx_Dev1
[Wr1,z1,Wt1] = sig_compare(rxbeam_5,rxbeam_6,Wr_beam1,Wr_beam2,Wt_beam3,Wt_beam3);
[Wr2,z2,Wt2] = sig_compare(rxbeam_7,rxbeam_8,Wr_beam1,Wr_beam2,Wt_beam4,Wt_beam4);
[Wr_next5,x,Wt_next6] = sig_compare(z1,z2,Wr1,Wr2,Wt1,Wt2);
ula3 = plotpattern(fp,tp,Wt_next6.');
ula4 = plotpattern(fp,tp,Wr_next5.');
figure;
subplot(221)
    plotResponse(ula1,fp.fc,fp.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',-90:90);
    title('Dev1-txbeam');
subplot(222)
    plotResponse(ula2,fp.fc,fp.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',union(-180:-90,90:180));
    title('Dev2-rxbeam');
subplot(224)
    plotResponse(ula3,fp.fc,fp.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',union(-180:-90,90:180));
    title('Dev2-txbeam');
subplot(223)
    plotResponse(ula4,fp.fc,fp.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',-90:90);
    title('Dev1-rxbeam');

