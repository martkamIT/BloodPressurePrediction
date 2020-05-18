function varargout = BIOC_GUI(varargin)
% BIOC_GUI MATLAB code for BIOC_GUI.fig
global bioc_net;
if (~isstruct(bioc_net))
    bioc_net = struct('net', []);
end
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BIOC_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @BIOC_GUI_OutputFcn, ...
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


function BIOC_GUI_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for BIOC_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


function varargout = BIOC_GUI_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


function edit2_Callback(hObject, eventdata, handles)
% Dopisz do bazy danych ciœnienie skurczowe

cisnienie = importdata('cisnienie.txt', 'cisnienie');
[m n] = size(cisnienie);


str = get(handles.edit2, 'String');
str(ismember(str, '-+eEgG')) = ' ';
str2 = sprintf('%g', sscanf(str, '%g', 1));
if ~all(ismember(str, '.1234567890'))
    f = warndlg('Wpisz pawid³ow¹ wartoœæ liczbow¹!','Warning');
    set(handles.edit2, 'String', '');
else
    set(handles.edit2, 'String', str2);
    c_s = str2num(char(get(handles.edit2,'String')));
    cisnienie(1,n+1) = c_s;
    save('cisnienie.txt', 'cisnienie');
end


function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_Callback(hObject, eventdata, handles)
% Dopisane do bazy ciœnienie atmosferyczne

cisnienie = importdata('cisnienie.txt', 'cisnienie');
[m n] = size(cisnienie);


str = get(handles.edit3, 'String');
str(ismember(str, '-+eEgG')) = ' ';
str2 = sprintf('%g', sscanf(str, '%g', 1));
if ~all(ismember(str, '.1234567890'))
    f = warndlg('Wpisz pawid³ow¹ wartoœæ liczbow¹!','Warning');
    set(handles.edit3, 'String', '');
else
    set(handles.edit3, 'String', str2);
    c_a = str2num(char(get(handles.edit3,'String')));
    cisnienie(2,n) = c_a;
    save('cisnienie.txt', 'cisnienie');
end


function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton1_Callback(hObject, eventdata, handles)
% Wczytaj bazê danych
cisnienie = xlsread('BD.xlsx');
save('cisnienie.txt', 'cisnienie');

cisnienie = importdata('cisnienie.txt', 'cisnienie');
save('cisnienie.txt', 'cisnienie');


function pushbutton2_Callback(hObject, eventdata, handles)
% Trenowanie sieci
global bioc_net;

cisnienie = importdata('cisnienie.txt', 'cisnienie');
inputs = cisnienie(2,:);
targets = cisnienie(1,:);
net = feedforwardnet(10);
[net,tr] = train(net,inputs,targets);
bioc_net.net = net;




function edit5_Callback(hObject, eventdata, handles)
% Przewidywane ciœnienie atmosferyczne
global bioc_net;

str = get(handles.edit5, 'String');
str(ismember(str, '-+eEgG')) = ' ';
str2 = sprintf('%g', sscanf(str, '%g', 1));
if ~all(ismember(str, '.1234567890'))
    f = warndlg('Wpisz pawid³ow¹ wartoœæ liczbow¹!','Warning');
    set(handles.edit5, 'String', '');
else
    set(handles.edit5, 'String', str2);
    c_a_p = str2num(char(get(handles.edit5,'String')));
    net = bioc_net.net;
    outputCS = net(c_a_p);
    set(handles.edit4, 'String', outputCS);
end



function edit5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
