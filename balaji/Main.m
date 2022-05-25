function varargout = Main(varargin)

%  This is the main MATLAB GUI function of implementation of algorithm presented in
%  "Speech Enhancement in Adverse Environment Based on Non-stationary Noise-driven 
%  Spectral Subtraction and SNR-dependent Phase Compensation" by M. T. Islam, C. Shahnaz, W. P. Zhu
%  and M. O. Ahmad submitted to Signal Processing, Elsevier.

% Developed by Md Tauhidul Islam, Department of Biomedical Engineering,
% Texas A&M University,College Station, Texas,USA, Email:tauhid@tamu.edu.

% Copyright (c) 2015. Prof Celia Shahnaz.
% All rights reserved.

% MAIN MATLAB code for Main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Main

% Last Modified by GUIDE v2.5 17-Aug-2016 16:49:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Main_OpeningFcn, ...
    'gui_OutputFcn',  @Main_OutputFcn, ...
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


% --- Executes just before Main is made visible.
function Main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Main (see VARARGIN)

% Choose default command line output for Main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Main_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Enhance.
function Enhance_Callback(hObject, eventdata, handles)
% hObject    handle to Enhance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(handles.PopSelectMethod,'String');
SelectMethodValue = contents{get(handles.PopSelectMethod,'Value')};
filename=get(handles.TextDirectoryNoisy,'String');
if (strcmp(filename,'Directory'))
    disp('Error!!!No noisy file has been chosen')
else
    
    [x fs] = audioread(filename);
    switch SelectMethodValue
       
        case 'MBSS'
            outputKamath=SSMultibandKamath02(x,fs);
            filename='outputKamath.wav';
            audiowrite(filename,outputKamath,fs);
            disp('Speech enhancement by MBSS method done.');
            
        case 'PSC'
            outputPSC = psc( x, fs, 25, 25/2, 'Griffin & Lim', 3.74 );
            filename='outputPSC.wav';
            audiowrite(filename,outputPSC,fs);
            disp('Speech enhancement by PSC method done.');
            
        case 'SMPO'
            mss_smpo(filename,'smpo_xre.wav');
            outputSMPO=audioread('smpo_xre.wav');
            filename='outputSMPO.wav';
            audiowrite(filename,outputSMPO,fs);
            disp('Speech enhancement by SMPO method done.');
            
        case 'NSSP'
            outputNSSP=NSSP(x,fs);
            filename='outputNSSP.wav';
            audiowrite(filename,outputNSSP,fs);
            disp('Speech enhancement by NSSP method done.');
    end
end
% --- Executes on selection change in PopSelectMethod.
function PopSelectMethod_Callback(hObject, eventdata, handles)
% hObject    handle to PopSelectMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PopSelectMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PopSelectMethod


% --- Executes during object creation, after setting all properties.
function PopSelectMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PopSelectMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ButtonShowSpectrogram.
function ButtonShowSpectrogram_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonShowSpectrogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(handles.PopSelectMethod,'String');
SelectMethodValue = contents{get(handles.PopSelectMethod,'Value')};
filename=get(handles.TextDirectoryNoisy,'String');
if (strcmp(filename,'Directory'))
    disp('Error!!!No enhancement has been done. Please enhance first.')
else
    switch SelectMethodValue
                  
        case 'MBSS'
            filename='outputKamath.wav';
            [outputKamath fs] = audioread(filename);
            figure
            myspectrogram(outputKamath)
         
            
        case 'PSC'
            filename='outputPSC.wav';
            [outputPSC fs] = audioread(filename);
            figure
            myspectrogram(outputPSC)
         
            
        case 'SMPO'
            filename='outputSMPO.wav';
            [outputSMPO fs] = audioread(filename);
            figure
            myspectrogram(outputSMPO)
        
            
        case 'NSSP'
            filename='outputNSSP.wav';
            [outputNSSP fs] = audioread(filename);
            figure
            myspectrogram(outputNSSP)
         
    end
end

% --- Executes on button press in ButtonShowIndex.
function ButtonShowIndex_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonShowIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(handles.PopSelectMethod,'String');
SelectMethodValue = contents{get(handles.PopSelectMethod,'Value')};
filename=get(handles.TextDirectoryNoisy,'String');
cleanfilename=get(handles.TextDirectoryClean,'String');
if (strcmp(filename,'Directory'))
    disp('Error!!!No enhancement has been done. Please enhance first.');
elseif (strcmp(cleanfilename,'Directory'))
    disp('Error!!!No clean file loaded. Please load clean file first.')
else
    switch SelectMethodValue
      
        case 'MBSS'
            filename='outputKamath.wav';
            [outputKamath fs] = audioread(filename);
            cleanfile=get(handles.TextDirectoryClean,'String');
            [clean fs] = audioread(cleanfile);
            [overall_snr, segmental_snr] = calcSNR(clean, outputKamath,fs);
            noisyfile=get(handles.TextDirectoryNoisy,'String');
            [noisy fs] = audioread(noisyfile);
            [overall_snrNoisy, segmental_snrNoisy] = calcSNR(clean, noisy,fs);
            
            set(handles.TextSNRSeg, 'String', num2str(segmental_snr-segmental_snrNoisy));
            set(handles.TextSNROvl, 'String', num2str(overall_snr-overall_snrNoisy));
            
        case 'PSC'
            filename='outputPSC.wav';
            [outputPSC fs] = audioread(filename);
            cleanfile=get(handles.TextDirectoryClean,'String');
            [clean fs] = audioread(cleanfile);
            [overall_snr, segmental_snr] = calcSNR(clean, outputPSC,fs);
            noisyfile=get(handles.TextDirectoryNoisy,'String');
            [noisy fs] = audioread(noisyfile);
            [overall_snrNoisy, segmental_snrNoisy] = calcSNR(clean, noisy,fs);
            
            set(handles.TextSNRSeg, 'String', num2str(segmental_snr-segmental_snrNoisy));
            set(handles.TextSNROvl, 'String', num2str(overall_snr-overall_snrNoisy));
            
        case 'SMPO'
            filename='outputSMPO.wav';
            [outputSMPO fs] = audioread(filename);
            cleanfile=get(handles.TextDirectoryClean,'String');
            [clean fs] = audioread(cleanfile);
            [overall_snr, segmental_snr] = calcSNR(clean, outputSMPO,fs);
            noisyfile=get(handles.TextDirectoryNoisy,'String');
            [noisy fs] = audioread(noisyfile);
            [overall_snrNoisy, segmental_snrNoisy] = calcSNR(clean, noisy,fs);
            
            set(handles.TextSNRSeg, 'String', num2str(segmental_snr-segmental_snrNoisy));
            set(handles.TextSNROvl, 'String', num2str(overall_snr-overall_snrNoisy));
            
            
        case 'NSSP'
            filename='outputNSSP.wav';
            [outputNSSP fs] = audioread(filename);
            cleanfile=get(handles.TextDirectoryClean,'String');
            [clean fs] = audioread(cleanfile);
            [overall_snr, segmental_snr] = calcSNR(clean, outputNSSP,fs);
            noisyfile=get(handles.TextDirectoryNoisy,'String');
            [noisy fs] = audioread(noisyfile);
            [overall_snrNoisy, segmental_snrNoisy] = calcSNR(clean, noisy,fs);
            
            set(handles.TextSNRSeg, 'String', num2str(segmental_snr-segmental_snrNoisy));
            set(handles.TextSNROvl, 'String', num2str(overall_snr-overall_snrNoisy));
            
    end
end

% --- Executes on button press in ButtonBrowseNoisy.
function ButtonBrowseNoisy_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonBrowseNoisy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.wav','Select the noisy .wav file');
directory=strcat(PathName,FileName);
set(handles.TextDirectoryNoisy, 'String', directory);


% --- Executes on button press in ButtonBrowseClean.
function ButtonBrowseClean_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonBrowseClean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.wav','Select the noisy .wav file');
directory=strcat(PathName,FileName);
set(handles.TextDirectoryClean, 'String', directory);
