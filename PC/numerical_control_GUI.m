function varargout = numerical_control_GUI(varargin)
% NUMERICAL_CONTROL_GUI MATLAB code for numerical_control_GUI.fig
%      NUMERICAL_CONTROL_GUI, by itself, creates a new NUMERICAL_CONTROL_GUI or raises the existing
%      singleton*.
%
%      H = NUMERICAL_CONTROL_GUI returns the handle to a new NUMERICAL_CONTROL_GUI or the handle to
%      the existing singleton*.
%
%      NUMERICAL_CONTROL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NUMERICAL_CONTROL_GUI.M with the given input arguments.
%
%      NUMERICAL_CONTROL_GUI('Property','Value',...) creates a new NUMERICAL_CONTROL_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before numerical_control_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to numerical_control_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help numerical_control_GUI

% Last Modified by GUIDE v2.5 10-Jul-2016 16:20:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @numerical_control_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @numerical_control_GUI_OutputFcn, ...
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


% --- Executes just before numerical_control_GUI is made visible.
function numerical_control_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to numerical_control_GUI (see VARARGIN)

% Choose default command line output for numerical_control_GUI
handles.output = hObject;

set(hObject,'toolbar','figure');
set(gcf,'menubar','figure');

handles.startx = 0;
handles.starty = 0;

handles.shape = int8(1);
handles.method = int8(1);
handles.Xs = int16(0);
handles.Ys = int16(0);
handles.Xe = int16(0);
handles.Ye = int16(0);
handles.direct = int8(0);
handles.speed = int8(0);
handles.accelerate = int8(0);

handles.x1 = 0;
handles.y1 = 0;
handles.x2 = 0;
handles.y2 = 0;
handles.x3 = 0;
handles.y3 = 0;
handles.sp = 0;
handles.acc = 0;

set(handles.radiobutton1,'value',0);
set(handles.radiobutton2,'value',1);
set(handles.radiobutton3,'value',0);
set(handles.radiobutton4,'value',1);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',0);

subplot(handles.axes1)
axis([-100 100 -100 100]);
axis equal;
grid on;
box on;
hold on;
 handles.o_SerialPort = serial('COM1','BaudRate',9600,'DataBits',8);
set(handles.o_SerialPort,'InputBufferSize',1024000);
handles.o_SerialPort.BytesAvailableFcnMode='byte';
handles.o_SerialPort.BytesAvailableFcnCount=1; 
handles.o_SerialPort.BytesAvailableFcn={@EveBytesAvailableFcn,handles};
fopen(handles.o_SerialPort);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes numerical_control_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = numerical_control_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.shape = int8(0);
handles.direct = int8(0);
set(handles.radiobutton1,'value',1);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',0);
set(handles.text5,'visible','off');
set(handles.edit_x3,'visible','off');
set(handles.edit_y3,'visible','off');
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.shape = int8(1);
handles.direct = int8(0);
set(handles.radiobutton1,'value',0);
set(handles.radiobutton2,'value',1);
set(handles.radiobutton3,'value',0);
set(handles.text5,'visible','on');
set(handles.edit_x3,'visible','on');
set(handles.edit_y3,'visible','on');
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.shape = int8(1);
handles.direct = int8(1);
set(handles.radiobutton1,'value',0);
set(handles.radiobutton2,'value',0);
set(handles.radiobutton3,'value',1);
set(handles.text5,'visible','on');
set(handles.edit_x3,'visible','on');
set(handles.edit_y3,'visible','on');
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.method = int8(1);
set(handles.radiobutton4,'value',1);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',0);
% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.method = int8(2);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',1);
set(handles.radiobutton6,'value',0);
% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.method = int8(3);
set(handles.radiobutton4,'value',0);
set(handles.radiobutton5,'value',0);
set(handles.radiobutton6,'value',1);
% Hint: get(hObject,'Value') returns toggle state of radiobutton6


function edit_x1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject,'String');
handles.x1 = str2double(str);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit_x1 as text
%        str2double(get(hObject,'String')) returns contents of edit_x1 as a double


% --- Executes during object creation, after setting all properties.
function edit_x1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_x1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_y1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject,'String');
handles.y1 = str2double(str);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit_y1 as text
%        str2double(get(hObject,'String')) returns contents of edit_y1 as a double


% --- Executes during object creation, after setting all properties.
function edit_y1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_y1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_x2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject,'String');
handles.x2 = str2double(str);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit_x2 as text
%        str2double(get(hObject,'String')) returns contents of edit_x2 as a double


% --- Executes during object creation, after setting all properties.
function edit_x2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_y2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject,'String');
handles.y2 = str2double(str);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit_y2 as text
%        str2double(get(hObject,'String')) returns contents of edit_y2 as a double


% --- Executes during object creation, after setting all properties.
function edit_y2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_x3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_x3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject,'String');
handles.x3 = str2double(str);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit_x3 as text
%        str2double(get(hObject,'String')) returns contents of edit_x3 as a double


% --- Executes during object creation, after setting all properties.
function edit_x3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_x3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_y3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_y3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject,'String');
handles.y3 = str2double(str);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit_y3 as text
%        str2double(get(hObject,'String')) returns contents of edit_y3 as a double


% --- Executes during object creation, after setting all properties.
function edit_y3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_y3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_speed_Callback(hObject, eventdata, handles)
% hObject    handle to edit_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject,'String');
handles.sp = str2double(str);
handles.speed = int8(handles.sp);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit_speed as text
%        str2double(get(hObject,'String')) returns contents of edit_speed as a double


% --- Executes during object creation, after setting all properties.
function edit_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_acc_Callback(hObject, eventdata, handles)
% hObject    handle to edit_acc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(hObject,'String');
handles.acc = str2double(str);
handles.accelerate = int8(handles.acc);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit_acc as text
%        str2double(get(hObject,'String')) returns contents of edit_acc as a double


% --- Executes during object creation, after setting all properties.
function edit_acc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_acc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton_start.
function pushbutton_start_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.shape == 0)
	handles.Xs = int16(0);
    handles.Ys = int16(0);
    handles.Xe = int16(handles.x2 - handles.x1);
    handles.Ye = int16(handles.y2 - handles.y1);
else
    handles.Xs = int16(handles.x1 - handles.x3);
    handles.Ys = int16(handles.y1 - handles.y3);
    handles.Xe = int16(handles.x2 - handles.x3);
    handles.Ye = int16(handles.y2 - handles.y3);
end
handles.startx = handles.x1;
handles.starty = handles.y1;
%% serial communication start
% handles.o_SerialPort = serial('COM1','BaudRate',9600,'DataBits',8);
% set(handles.o_SerialPort,'InputBufferSize',1024000);
% handles.o_SerialPort.BytesAvailableFcnMode='byte';
% handles.o_SerialPort.BytesAvailableFcnCount=1; 
% handles.o_SerialPort.BytesAvailableFcn={@EveBytesAvailableFcn,handles};
% fopen(handles.o_SerialPort);
handles
%% transaction
fwrite(handles.o_SerialPort,handles.shape,'int8');%shape
fwrite(handles.o_SerialPort,handles.method,'int8');%method
fwrite(handles.o_SerialPort,handles.Xs,'int16');%Xs
fwrite(handles.o_SerialPort,handles.Ys,'int16');%Ys
fwrite(handles.o_SerialPort,handles.Xe,'int16');%Xe
fwrite(handles.o_SerialPort,handles.Ye,'int16');%Ye
fwrite(handles.o_SerialPort,handles.direct,'int8');%direct
fwrite(handles.o_SerialPort,handles.speed,'int8');%max_speed
fwrite(handles.o_SerialPort,handles.accelerate,'int8');%accelerate
guidata(hObject, handles);


%% get serial data in 1 byte
function EveBytesAvailableFcn(hObject, eventdata, handles )
%% out
handles.move = fread(handles.o_SerialPort,1)-48;
handles.oldx = handles.startx;
handles.oldy = handles.starty;
if handles.move ==1
    handles.startx = handles.startx + 1;
elseif handles.move ==2
    handles.startx = handles.startx - 1;
elseif handles.move ==3
    handles.starty = handles.starty + 1;
elseif handles.move ==4
    handles.starty = handles.starty - 1 ;
end
handles
PB1_Callback (handles.PB1,eventdata,handles);
guidata(handles.PB1,handles) ;%% function ends

% --- Executes on button press in pushbutton_clear.
function pushbutton_clear_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fclose(handles.o_SerialPort);
% Hint: delete(hObject) closes the figure
delete(hObject);

%% dummy button- just for transform handles
% --- Executes on button press in PB1.
function PB1_Callback(hObject, eventdata, handles)
% hObject    handle to PB1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles
handles.o_SerialPort.BytesAvailableFcn={@EveBytesAvailableFcn,handles};
subplot(handles.axes1);
line( [ handles.oldx  handles.startx] , [ handles.oldy  handles.starty ] );
axis([-100 100 -100 100]);
axis equal;
grid on;
box on;
hold on;
guidata(hObject,handles) ;%% dummy button function ends
