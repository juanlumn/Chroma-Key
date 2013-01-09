function varargout = ChromaGUI(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ChromaGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ChromaGUI_OutputFcn, ...
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

% --- Executes just before ChromaGUI is made visible.
function ChromaGUI_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
% --- Outputs from this function are returned to the command line.
function varargout = ChromaGUI_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;

%Callback to Load Picture
function Imagen_Callback(~, ~, handles)
%Set the new button to 0
set(handles.Imagen,'Value',0);
%Loading Picture menu
I=double(imread(uigetfile({'*.jpg'})));
%Saves the picture in im1.jpg
imwrite(uint8(I),'im1.jpg');
%Shows the picture in axes1
axes(handles.axes1);imshow(uint8(I));
set(handles.Fondo,'Visible','on');
%End of Load Picture Callback

%Callback to Load the Background
function Fondo_Callback(~, ~, handles)
%It's the same but this time the picture is
%Saved in im2.jpg
set(handles.Fondo,'Value',0);
I=double(imread(uigetfile({'*.jpg'})));
imwrite(uint8(I),'im2.jpg');
axes(handles.axes3);imshow(uint8(I));
set(handles.Croma,'Visible','on');
%End of Load Background Callback

%Callback of Chroma key button
function Croma_Callback(~, ~, handles)
set(handles.Croma,'Value',0);
I1=(imread('im1.jpg'));
I2=(imread('im2.jpg'));
%RGB to HSI
[H1,S1,V1]=rgb2hsv(I1);
%Computes the average of the first row
media=round(mean(H1(1,:))*360);
%Chroma.m
I3=Chroma(I1,I2,media,50);
axes(handles.axes4);imshow((I3));
set(handles.uipanel1,'Visible','on');
%Media will be the default average value
set(handles.valormedio,'String', num2str(media));
set(handles.matiz,'Value',media);
set(handles.valormatiz,'String',media);
%Default tolerance 50
set(handles.valortolerancia,'String', num2str(50));
set(handles.tolerancia,'Value',50);
%Inits the color circle
B=imrotate(imread('circulo.jpg'),-(media),'nearest','crop');
axes(handles.axes5);imshow(B);
axes(handles.axes7);imshow('flecha.jpg')
%End of Chroma key Callback

%HUE Slider
function matiz_Callback(~, ~, handles)
%Media gets the HUE value
media=round(get(handles.matiz,'Value'));
set(handles.valormatiz,'String',num2str(media));
%Tolerancia gets the Tolerance value
tolerancia=round(get(handles.tolerancia,'Value'));
B=imrotate(imread('circulo.jpg'),-media,'nearest','crop');
axes(handles.axes5);imshow(B);
I3=Chroma(imread('im1.jpg'),imread('im2.jpg'),media,tolerancia);
axes(handles.axes4);imshow((I3));

%Tolerance Slider
function tolerancia_Callback(~, ~, handles)
tolerancia=round(get(handles.tolerancia,'Value'));
set(handles.valortolerancia,'String', tolerancia);
media=round(get(handles.matiz,'Value'));
I3=Chroma(imread('im1.jpg'),imread('im2.jpg'),media,tolerancia);
axes(handles.axes4);imshow((I3));

%Function to get the HUE value from the picture with the mouse
function matizmanual_Callback(hObject, ~, handles)
if get(hObject,'Value') 
    %Gets the pointer position A(1)=X,A(2)=Y
    A=uint16(ginput(1));
    %Gets the RGB value from the selected pixel
    I1=double(imread('im1.jpg'));
    Rr=I1(A(2),A(1),1);
    Gr=I1(A(2),A(1),2);
    Br=I1(A(2),A(1),3);
    %Computes the H value
    Hr=acos(0.5*((Rr-Gr)+(Rr-Br))./sqrt((Rr-Gr).^2+(Rr-Br).*(Gr-Br))+eps);
    Hr(Br>Gr)=(2*pi)-Hr(Br>Gr);
    media=round((Hr/(2*pi))*360);
    %Set the default average value
    set(handles.valormedio,'String',num2str(media));
    set(handles.valormatiz,'String',num2str(media));
    set(handles.matiz,'Value',media);
    %Rounds the circle in order to show the selected color 
    B=imrotate(imread('circulo.jpg'),-media,'nearest','crop');
    axes(handles.axes5);imshow(B);
    %Sets the Tolerance value
    tolerancia=round(get(handles.tolerancia,'Value'));
    I3=Chroma(imread('im1.jpg'),imread('im2.jpg'),media,tolerancia);
    axes(handles.axes4);imshow((I3));
    set(hObject,'Value',0); 
end

%Low Pass Filter
function FPB_Callback(hObject, eventdata, handles)
if get(hObject,'Value')
    set(hObject,'Value',0);
    H=fspecial('average');
    I4=imfilter(imread('im1.jpg'),H);
    tolerancia=round(get(handles.tolerancia,'Value'));
    media=round(get(handles.matiz,'Value'));
    I3=Chroma(I4,imread('im2.jpg'),media,tolerancia);
    imwrite(uint8(I4),'im1.jpg');
    axes(handles.axes4);imshow((I3));
end

% --- Executes during object creation, after setting all properties.
function Imagen_CreateFcn(~, ~, ~)
function Fondo_CreateFcn(~, ~, ~)
function matiz_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function tolerancia_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function Croma_CreateFcn(~, ~, ~)
function valormedio_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function valormatiz_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function valortolerancia_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function matizmanual_CreateFcn(~, ~, ~)
function uipanel1_CreateFcn(~, ~, ~)
function axes7_CreateFcn(~, ~, ~)
function axes5_CreateFcn(~, ~, ~)
function figure1_CreateFcn(hObject, eventdata, handles)
function FPB_CreateFcn(hObject, eventdata, handles)
