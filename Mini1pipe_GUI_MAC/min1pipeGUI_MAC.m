function varargout = min1pipeGUI_MAC(varargin)
% MIN1PIPEGUI_MAC MATLAB code for min1pipeGUI_MAC.fig
%      MIN1PIPEGUI_MAC, by itself, creates a new MIN1PIPEGUI_MAC or raises the existing
%      singleton*.
%
%      H = MIN1PIPEGUI_MAC returns the handle to a new MIN1PIPEGUI_MAC or the handle to
%      the existing singleton*.
%
%      MIN1PIPEGUI_MAC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MIN1PIPEGUI_MAC.M with the given input arguments.
%
%      MIN1PIPEGUI_MAC('Property','Value',...) creates a new MIN1PIPEGUI_MAC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before min1pipeGUI_MAC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to min1pipeGUI_MAC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help min1pipeGUI_MAC

% Last Modified by GUIDE v2.5 08-Jan-2020 17:43:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @min1pipeGUI_MAC_OpeningFcn, ...
                   'gui_OutputFcn',  @min1pipeGUI_MAC_OutputFcn, ...
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


% --- Executes just before min1pipeGUI_MAC is made visible.
function min1pipeGUI_MAC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to min1pipeGUI_MAC (see VARARGIN)

% Choose default command line output for min1pipeGUI_MAC
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes min1pipeGUI_MAC wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = min1pipeGUI_MAC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Moises AC 08.ene.2020


%%%%%%%%%%%%%%%%%%%%%% PARAMS BUTTON %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Frame Rate
function Fsi_Callback(hObject, eventdata, handles)
% Defult Frame Rate = 20

Fsi = str2double(get(hObject,'String'));
set(handles.Fsi,'UserData',Fsi)
function Fsi_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Temporal Downsampling
function Fsi_new_Callback(hObject, eventdata, handles)
% If Fsi_new = 20, no temporal downsampling
 Fsi_new = str2double(get(hObject,'String'));
 set(handles.Fsi_new,'UserData',Fsi_new)
function Fsi_new_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Spatial Downsampling.
function spatialr_Callback(hObject, eventdata, handles)
% If spatialr = 1; no spatial downsampling %%%
spatialr = str2double(get(hObject,'String'));
set(handles.spatialr,'UserData',spatialr)
function spatialr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Neuron size
function NeuronSize_Callback(hObject, eventdata, handles)
% Recommanded Neuron size = 5

NeuronSize = str2double(get(hObject,'String'));
set(handles.NeuronSize,'UserData',NeuronSize)
function NeuronSize_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% If Movement Correction
function MoveCorrGroup_SelectionChangedFcn(hObject, eventdata, handles)

MoveCorrGroup = get(hObject,'String');
switch MoveCorrGroup
    case 'Yes'
    ismc = true;
    case 'No'
    ismc = false;
end
set(handles.MoveCorrGroup,'UserData',ismc)
 
% If Auto Seed Selection
function SeedSelecGroup_SelectionChangedFcn(hObject, eventdata, handles)
 % 1 use auto seeds selection; 2 if manual
 SeedSelecGroup = get(hObject,'String');
switch SeedSelecGroup
    case 'Yes'
    flag = 1;
    case 'No'
    flag = 0;
end

set(handles.SeedSelecGroup,'UserData',flag)

% If Create Graphics 
function CreateGraphGroup_SelectionChangedFcn(hObject, eventdata, handles)
CreateGraphGroup = get(hObject,'String');
switch CreateGraphGroup
    case 'Yes'
        Graph = 1;
    case 'No'
        Graph = 0;       
end
set(handles.CreateGraphGroup,'UserData',Graph)

%%%%%%%%%%%%%%%%%%%%%%%%% Min1pipe MAIN PROGRAM %%%%%%%%%%%%%%%%%%%%%%%%%%% 

function RunButton_Callback(hObject, eventdata, handles)

% Get values for input function 
Fsi = get(handles.Fsi,'UserData');
Fsi_new = get(handles.Fsi_new,'UserData');
spatialr = get(handles.spatialr,'UserData');
neuron_size = get(handles.NeuronSize,'UserData');
ismc = get(handles.MoveCorrGroup,'UserData');
flag = get(handles.SeedSelecGroup,'UserData');
Graph =  get(handles.CreateGraphGroup,'UserData');

% Run principal function
[file_name_to_save, filename_raw, filename_reg] = min1pipe(Fsi,Fsi_new,spatialr,neuron_size,ismc,flag);


% In case of plot some figures
if Graph == 1
    
assignin('base','file_name_to_save',file_name_to_save);
data_processed = importdata(file_name_to_save);

imaxn = data_processed.imaxn;
imaxy = data_processed.imaxy;
imax = data_processed.imax;
roifn = data_processed.roifn;
sigfn = data_processed.sigfn;
seedsfn = data_processed.seedsfn;
pixh = data_processed.pixh;
pixw = data_processed.pixw;
sigfnr = data_processed.sigfnr;

figure(1)
%%% raw max %%%
subplot(1, 3, 1, 'align')
imagesc(imaxn)
axis square
title('Raw')

%%% neural enhanced before movement correction %%%3
subplot(1, 3, 2, 'align')
imagesc(imaxy)
axis square
title('Before MC')

%%% neural enhanced after movement correction %%%
subplot(1, 3, 3, 'align')
imagesc(imax)
axis square
title('After MC')

figure(2)
%%% contour %%%
subplot(1, 2, 1, 'align')
plot_contour(roifn, sigfn, seedsfn, imax, pixh, pixw)
axis square

%%% all identified traces %%%
subplot(1, 2, 2, 'align')
sigt = sigfnr;
for i = 1: size(sigt, 1)
    sigt(i, :) = normalize(sigt(i, :));
end
plot((sigt + (1: size(sigt, 1))')')
axis tight

axis square
title('Traces')
end