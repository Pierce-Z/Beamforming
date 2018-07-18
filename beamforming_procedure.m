function varargout = beamforming_procedure(varargin)
% BEAMFORMING_PROCEDURE MATLAB code for beamforming_procedure.fig
%      BEAMFORMING_PROCEDURE, by itself, creates a new BEAMFORMING_PROCEDURE or raises the existing
%      singleton*.
%
%      H = BEAMFORMING_PROCEDURE returns the handle to a new BEAMFORMING_PROCEDURE or the handle to
%      the existing singleton*.
%
%      BEAMFORMING_PROCEDURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BEAMFORMING_PROCEDURE.M with the given input arguments.
%
%      BEAMFORMING_PROCEDURE('Property','Value',...) creates a new BEAMFORMING_PROCEDURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before beamforming_procedure_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to beamforming_procedure_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help beamforming_procedure

% Last Modified by GUIDE v2.5 16-Jul-2018 15:35:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @beamforming_procedure_OpeningFcn, ...
                   'gui_OutputFcn',  @beamforming_procedure_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before beamforming_procedure is made visible.
function beamforming_procedure_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to beamforming_procedure (see VARARGIN)

% Choose default command line output for beamforming_procedure
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes beamforming_procedure wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = beamforming_procedure_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in omnipushd11.
function omnipushd11_Callback(hObject, eventdata, handles)
global gc;
global tp;
% Fixed parameters
gc.cLight = 3e8;
gc.fc = 28e9;   % 28 GHz  Band
gc.lambda = gc.cLight/gc.fc;
gc.nT = 290; 
gc.scanAz = -180:180;

% Tunable parameters
tp.txPower = 5000;           % watt
tp.txGain = 20;           % dB
tp.noisefigure = 10;
tp.f0 = 28e9; %sample rate = noisewidth
antenna_num = get(handles.edit1,'string');

tp.numTXElements = abs(str2num(antenna_num));       

tp.N_sgnl = 1000;
numTx= tp.numTXElements;
tp.rxGain = tp.txGain; % dB


SNR_s= get(handles.edit3,'string');
SNR = str2double(SNR_s);
angle_s1 = get(handles.edit2,'string');
% angle_s2 = get(handles.edit4,'string');
angle1 = str2double(angle_s1);
% angle2 = str2double(angle_s2);
Dev2toDev1 = [angle1; 0];
Dev1toDev2 = [angle1-180; 0];
% Dev2toDev1 = - Dev2toDev1;
% Dev1toDev2 = - Dev1toDev2;
pos_r =  [10;0;0];
% signal formation
txsig = (randi(2 , tp.N_sgnl , 1) * 2 - 3)  + j * (randi(2 , tp.N_sgnl , 1) * 2 - 3);
%% First Signal Transmission 

% W_1 = codebk_select(**);
W_1 = [1 0 0 0  1 0 0 0 ];
% W_2 = codebk_select(**);
W_2 = [1 0 0 0 -1 0 0 0 ];
%Dev1  first training
txomni_1 = MIMOTx(gc,tp,W_1,txsig,Dev2toDev1);% configure the system's transmitter. 
sigLoss = MIMOEnvir(txomni_1,pos_r,gc,SNR);
rxomni_1 = MIMORx(gc,tp,W_1,sigLoss,Dev1toDev2);
rxomni_2 = MIMORx(gc,tp,W_2,sigLoss,Dev1toDev2);
%Dev1 second training
txomni_2 = MIMOTx(gc,tp,W_2,txsig,Dev2toDev1);% configure the system's receiver. 
sigLoss = MIMOEnvir(txomni_2,pos_r,gc,SNR);
rxomni_3 = MIMORx(gc,tp,W_1,sigLoss,Dev1toDev2);
rxomni_4 = MIMORx(gc,tp,W_2,sigLoss,Dev1toDev2);
%Dev2 first training
txomni_3 = MIMOTx(gc,tp,W_1,txsig,Dev1toDev2);% configure the system's transmitter. 
sigLoss = MIMOEnvir(txomni_3,pos_r,gc,SNR);
rxomni_5 = MIMORx(gc,tp,W_1,sigLoss,Dev2toDev1);
rxomni_6 = MIMORx(gc,tp,W_2,sigLoss,Dev2toDev1);
%Dev2 second training
txomni_4 = MIMOTx(gc,tp,W_2,txsig,Dev1toDev2);% configure the system's transmitter. 
sigLoss = MIMOEnvir(txomni_4,pos_r,gc,SNR);
rxomni_7 = MIMORx(gc,tp,W_1,sigLoss,Dev2toDev1);
rxomni_8 = MIMORx(gc,tp,W_2,sigLoss,Dev2toDev1);
%tx_Dev1 and rx_Dev2  
[Wr1,z1] = sig_compare(rxomni_1,rxomni_2,W_1,W_2,W_1,W_1);
[Wr2,z2] = sig_compare(rxomni_3,rxomni_4,W_1,W_2,W_2,W_2);
[Wr_next2,x,Wt_next1] = sig_compare(z1,z2,Wr1,Wr2,W_1,W_2);
global sig_pow1;
sig_pow1(1,1) = abs(sum(rxomni_1));
sig_pow1(2,1) = abs(sum(rxomni_2));
sig_pow1(3,1) = abs(sum(rxomni_3));
sig_pow1(4,1) = abs(sum(rxomni_4));
%tx_Dev2 and rx_Dev1
[Wr1,z1] = sig_compare(rxomni_5,rxomni_6,W_1,W_2,W_1,W_1);
[Wr2,z2] = sig_compare(rxomni_7,rxomni_8,W_1,W_2,W_2,W_2);
[Wr_next1,x,Wt_next2] = sig_compare(z1,z2,Wr1,Wr2,W_1,W_2);
% global sig_pow2;
sig_pow1(1,2) = abs(sum(rxomni_5));
sig_pow1(2,2) = abs(sum(rxomni_6));
sig_pow1(3,2) = abs(sum(rxomni_7));
sig_pow1(4,2) = abs(sum(rxomni_8));
%% First feedback and mapping
global Wt_sec1;
global Wt_sec2;
global Wt_sec3;
global Wt_sec4;
[Wt_sec1,Wt_sec2] = codebk_select(Wt_next1.',2);%tx_Dev1
[Wr_sec1,Wr_sec2] = codebk_select(Wr_next1.',2);%rx_Dev1
[Wt_sec3,Wt_sec4] = codebk_select(Wt_next2.',2);%tx_Dev2
[Wr_sec3,Wr_sec4] = codebk_select(Wr_next2.',2);%rx_Dev2
%% Second Signal Transmission
%tx  first training
txsec_1 = MIMOTx(gc,tp,Wt_sec1.',txsig,Dev2toDev1);% configure the system's transmitter. 
sigLoss = MIMOEnvir(txsec_1,pos_r,gc,SNR);
rxsec_1 = MIMORx(gc,tp,Wr_sec3.',sigLoss,Dev1toDev2);
rxsec_2 = MIMORx(gc,tp,Wr_sec4.',sigLoss,Dev1toDev2);

%tx second training
txsec_2 = MIMOTx(gc,tp,Wt_sec2.',txsig,Dev2toDev1);% configure the system's receiver. 
sigLoss = MIMOEnvir(txsec_2,pos_r,gc,SNR);
rxsec_3 = MIMORx(gc,tp,Wr_sec3.',sigLoss,Dev1toDev2);
rxsec_4 = MIMORx(gc,tp,Wr_sec4.',sigLoss,Dev1toDev2);
%rx first training
txsec_3 = MIMOTx(gc,tp,Wt_sec3.',txsig,Dev1toDev2);% configure the system's transmitter. 
sigLoss = MIMOEnvir(txsec_3,pos_r,gc,SNR);
rxsec_5 = MIMORx(gc,tp,Wr_sec1.',sigLoss,Dev2toDev1);
rxsec_6 = MIMORx(gc,tp,Wr_sec2.',sigLoss,Dev2toDev1);
%rx second training
txsec_4 = MIMOTx(gc,tp,Wt_sec4.',txsig,Dev1toDev2);% configure the system's transmitter. 
sigLoss = MIMOEnvir(txsec_4,pos_r,gc,SNR);
rxsec_7 = MIMORx(gc,tp,Wr_sec1.',sigLoss,Dev2toDev1);
rxsec_8 = MIMORx(gc,tp,Wr_sec2.',sigLoss,Dev2toDev1);
%tx_Dev1 and rx_Dev2  
[Wr1,z1,Wt1] = sig_compare(rxsec_1,rxsec_2,Wr_sec3,Wr_sec4,Wt_sec1,Wt_sec1);
[Wr2,z2,Wt2] = sig_compare(rxsec_3,rxsec_4,Wr_sec3,Wr_sec4,Wt_sec2,Wt_sec2);
[Wr_next4,x,Wt_next3] = sig_compare(z1,z2,Wr1,Wr2,Wt1,Wt2);
global sig_pow2;
sig_pow2(1,1) = abs(sum(rxsec_1));
sig_pow2(2,1) = abs(sum(rxsec_2));
sig_pow2(3,1) = abs(sum(rxsec_3));
sig_pow2(4,1) = abs(sum(rxsec_4));
%tx_Dev2 and rx_Dev1
[Wr1,z1,Wt1] = sig_compare(rxsec_5,rxsec_6,Wr_sec1,Wr_sec2,Wt_sec3,Wt_sec3);
[Wr2,z2,Wt2] = sig_compare(rxsec_7,rxsec_8,Wr_sec1,Wr_sec2,Wt_sec4,Wt_sec4);
[Wr_next3,x,Wt_next4] = sig_compare(z1,z2,Wr1,Wr2,Wt1,Wt2);
% global sig_pow4;
sig_pow2(1,2) = abs(sum(rxsec_5));
sig_pow2(2,2) = abs(sum(rxsec_6));
sig_pow2(3,2) = abs(sum(rxsec_7));
sig_pow2(4,2) = abs(sum(rxsec_8));
%% Second feedback and mapping
global Wt_beam1;
global Wt_beam2;
global Wt_beam3;
global Wt_beam4;
[Wt_beam1,Wt_beam2] = codebk_select(Wt_next3,3);%tx_Dev1
[Wr_beam1,Wr_beam2] = codebk_select(Wr_next3,3);%rx_Dev1
[Wt_beam3,Wt_beam4] = codebk_select(Wt_next4,3);%tx_Dev2
[Wr_beam3,Wr_beam4] = codebk_select(Wr_next4,3);%rx_Dev2
%% Third Signal Transmission
%tx  first training
txbeam_1 = MIMOTx(gc,tp,Wt_beam1.',txsig,Dev2toDev1);% configure the system's transmitter. 
sigLoss = MIMOEnvir(txbeam_1,pos_r,gc,SNR);
rxbeam_1 = MIMORx(gc,tp,Wr_beam3.',sigLoss,Dev1toDev2);
rxbeam_2 = MIMORx(gc,tp,Wr_beam4.',sigLoss,Dev1toDev2);

%tx second training
txbeam_2 = MIMOTx(gc,tp,Wt_beam2.',txsig,Dev2toDev1);% configure the system's receiver. 
sigLoss = MIMOEnvir(txbeam_2,pos_r,gc,SNR);
rxbeam_3 = MIMORx(gc,tp,Wr_beam3.',sigLoss,Dev1toDev2);
rxbeam_4 = MIMORx(gc,tp,Wr_beam4.',sigLoss,Dev1toDev2);
%rx first training
txbeam_3 = MIMOTx(gc,tp,Wt_beam3.',txsig,Dev1toDev2);% configure the system's transmitter. 
sigLoss = MIMOEnvir(txbeam_3,pos_r,gc,SNR);
rxbeam_5 = MIMORx(gc,tp,Wr_beam1.',sigLoss,Dev2toDev1);
rxbeam_6 = MIMORx(gc,tp,Wr_beam2.',sigLoss,Dev2toDev1);
%rx second training
txbeam_4 = MIMOTx(gc,tp,Wt_beam4.',txsig,Dev1toDev2);% configure the system's transmitter. 
sigLoss = MIMOEnvir(txbeam_4,pos_r,gc,SNR);
rxbeam_7 = MIMORx(gc,tp,Wr_beam1.',sigLoss,Dev2toDev1);
rxbeam_8 = MIMORx(gc,tp,Wr_beam2.',sigLoss,Dev2toDev1);
%tx_Dev1 and rx_Dev2  
[Wr1,z1,Wt1] = sig_compare(rxbeam_1,rxbeam_2,Wr_beam3,Wr_beam4,Wt_beam1,Wt_beam1);
[Wr2,z2,Wt2] = sig_compare(rxbeam_3,rxbeam_4,Wr_beam3,Wr_beam4,Wt_beam2,Wt_beam2);
[Wr_next6,x,Wt_next5] = sig_compare(z1,z2,Wr1,Wr2,Wt1,Wt2);
global sig_pow3;
sig_pow3(1,1) = abs(sum(rxbeam_1));
sig_pow3(2,1) = abs(sum(rxbeam_2));
sig_pow3(3,1) = abs(sum(rxbeam_3));
sig_pow3(4,1) = abs(sum(rxbeam_4));
%tx_Dev2 and rx_Dev1
[Wr1,z1,Wt1] = sig_compare(rxbeam_5,rxbeam_6,Wr_beam1,Wr_beam2,Wt_beam3,Wt_beam3);
[Wr2,z2,Wt2] = sig_compare(rxbeam_7,rxbeam_8,Wr_beam1,Wr_beam2,Wt_beam4,Wt_beam4);
[Wr_next5,x,Wt_next6] = sig_compare(z1,z2,Wr1,Wr2,Wt1,Wt2);
% global sig_pow6;
sig_pow3(1,2) = abs(sum(rxbeam_5));
sig_pow3(2,2) = abs(sum(rxbeam_6));
sig_pow3(3,2) = abs(sum(rxbeam_7));
sig_pow3(4,2) = abs(sum(rxbeam_8));
ula1 = plotpattern(gc,tp,[1 0 0 0 1 0 0 0]);
axes(handles.axes1);
plotResponse(ula1,gc.fc,gc.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',-90:90);
set(handles.uitable1,'data',sig_pow1);


% --- Executes on button press in beampushd11.
function beampushd11_Callback(hObject, eventdata, handles)
% hObject    handle to beampushd11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gc;
global tp;
global Wt_beam1;
global sig_pow3;

ula1 = plotpattern(gc,tp,Wt_beam1);
axes(handles.axes8);
plotResponse(ula1,gc.fc,gc.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',-90:90);
set(handles.uitable3,'data',sig_pow3);

% --- Executes on button press in beampushd12.
function beampushd12_Callback(hObject, eventdata, handles)
% hObject    handle to beampushd12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gc;
global tp;
global Wt_beam2;
ula1 = plotpattern(gc,tp,Wt_beam2);
axes(handles.axes8);
plotResponse(ula1,gc.fc,gc.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',-90:90);


% --- Executes on button press in beampushd21.
function beampushd21_Callback(hObject, eventdata, handles)
% hObject    handle to beampushd21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gc;
global tp;
global Wt_beam3;
ula1 = plotpattern(gc,tp,Wt_beam3);
axes(handles.axes9);
plotResponse(ula1,gc.fc,gc.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',union(-180:-90,90:180));


% --- Executes on button press in beampushd22.
function beampushd22_Callback(hObject, eventdata, handles)
% hObject    handle to beampushd22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gc;
global tp;
global Wt_beam4;
ula1 = plotpattern(gc,tp,Wt_beam4);
axes(handles.axes9);
plotResponse(ula1,gc.fc,gc.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',union(-180:-90,90:180));

% --- Executes on button press in omnipushd12.
function omnipushd12_Callback(hObject, eventdata, handles)
% hObject    handle to omnipushd12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gc;
global tp;
ula1 = plotpattern(gc,tp,[1 0 0 0 -1 0 0 0]);
axes(handles.axes1);
plotResponse(ula1,gc.fc,gc.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',-90:90);

% --- Executes on button press in omnipushd21.
function omnipushd21_Callback(hObject, eventdata, handles)
% hObject    handle to omnipushd21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gc;
global tp;
ula2 = plotpattern(gc,tp,[1 0 0 0 1 0 0 0]);
axes(handles.axes3);
plotResponse(ula2,gc.fc,gc.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',union(-180:-90,90:180));

% --- Executes on button press in omnipushd22.
function omnipushd22_Callback(hObject, eventdata, handles)
% hObject    handle to omnipushd22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gc;
global tp;
ula2 = plotpattern(gc,tp,[1 0 0 0 -1 0 0 0]);
axes(handles.axes3);
plotResponse(ula2,gc.fc,gc.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',union(-180:-90,90:180));

% --- Executes on button press in secpushd11.
function secpushd11_Callback(hObject, eventdata, handles)
% hObject    handle to secpushd11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gc;
global tp;
global Wt_sec1;
global sig_pow2;
ula1 = plotpattern(gc,tp,Wt_sec1);
axes(handles.axes6);
plotResponse(ula1,gc.fc,gc.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',-90:90);
set(handles.uitable2,'data',sig_pow2);

% --- Executes on button press in secpushd12.
function secpushd12_Callback(hObject, eventdata, handles)
% hObject    handle to secpushd12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gc;
global tp;
global Wt_sec2;
ula1 = plotpattern(gc,tp,Wt_sec2);
axes(handles.axes6);
plotResponse(ula1,gc.fc,gc.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',-90:90);

% --- Executes on button press in secpushd21.
function secpushd21_Callback(hObject, eventdata, handles)
% hObject    handle to secpushd21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gc;
global tp;
global Wt_sec3;
ula1 = plotpattern(gc,tp,Wt_sec3);
axes(handles.axes7);
plotResponse(ula1,gc.fc,gc.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',union(-180:-90,90:180));


% --- Executes on button press in secpushd22.
function secpushd22_Callback(hObject, eventdata, handles)
% hObject    handle to secpushd22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gc;
global tp;
global Wt_sec4;
ula1 = plotpattern(gc,tp,Wt_sec4);
axes(handles.axes7);
plotResponse(ula1,gc.fc,gc.cLight,'RespCut','Az','Format','Polar','Unit','dbi','AzimuthAngles',union(-180:-90,90:180));



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
