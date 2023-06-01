function varargout = frontend(varargin)
% FRONTEND MATLAB code for frontend.fig
%      FRONTEND, by itself, creates a new FRONTEND or raises the existing
%      singleton*.
%
%      H = FRONTEND returns the handle to a new FRONTEND or the handle to
%      the existing singleton*.
%
%      FRONTEND('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FRONTEND.M with the given input arguments.
%
%      FRONTEND('Property','Value',...) creates a new FRONTEND or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before frontend_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to frontend_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help frontend

% Last Modified by GUIDE v2.5 16-Mar-2018 13:05:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @frontend_OpeningFcn, ...
                   'gui_OutputFcn',  @frontend_OutputFcn, ...
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


% --- Executes just before frontend is made visible.
function frontend_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to frontend (see VARARGIN)

% Choose default command line output for frontend
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes frontend wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = frontend_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'Enter Roll Number:','Enter Name:','Enter Branch:','Enter Year:'};
title = 'Input';
dims = [1 35];
answer = inputdlg(prompt,title,dims);

conn = database('project','project','project');
fastinsert(conn,'student',{'RollNumber','Name','Branch','Year'},[answer(1),answer(2),answer(3),answer(4)]);


all_files = dir('C:\Users\NarsiReddy\Desktop\PCA_LDA\libsvm\dataset');
%all_dir = all_files([all_files(:).isdir]);
%num_dir = numel(all_dir);
%path1=strcat('.',num2str(num_dir-1));
%mkdir(path1);
l=length(all_files)-2;
for i=1:10
[fn,path,fi]=uigetfile('C:\Users\NarsiReddy\Downloads\project1');
path=strcat(path,fn);
faceDetector = vision.CascadeObjectDetector();
% Read a video frame and run the detector.
videoFileReader = vision.VideoFileReader(path);
videoFrame      = step(videoFileReader);
bbox            = step(faceDetector, videoFrame);
im=imcrop(videoFrame,bbox);
im=imresize(im,[38 24]);
imwrite(im,strcat('C:\Users\NarsiReddy\Desktop\PCA_LDA\libsvm\dataset\',num2str(l+i),'.jpg'));

end

close(conn);



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);

%vid=videoinput('winvideo',1);
%hImage=image(zeros(1200,500,3),'Parent',handles.axes1);
%preview(vid,hImage);
%set(vid, 'ReturnedColorSpace', 'RGB');
%img = getsnapshot(vid);
%stop(vid);
conn = database('project','project','project');
prompt = {'Enter Faculty ID'};
title = 'Input';
dims = [1 35];
answer1 = inputdlg(prompt,title,dims);
display(answer1);
%%query form period name
sqlquery='select pnumber from period where ((select (sysdate-trunc(sysdate))*24*60 from dual) >=time) and ((select (sysdate-trunc(sysdate))*24*60 from dual)<time+50)';
curs=exec(conn,sqlquery);
curs=fetch(curs);
display(curs.data{1});
%%query for getting day 
s='select to_char(SYSDATE,''DAY'') FROM DUAL';
curs2=exec(conn,s);
curs2=fetch(curs2);
display(curs2.data);
t1=strrep(curs2.data{1},' ','');
display(t1);
%%query for getting cname
s2=['select',' ',curs.data{1},' from timetable where day=''',t1,''''];
display(s2);
curs3=exec(conn,s2);
curs3=fetch(curs3);
display(curs3.data);
sqlquery1=['select fid from course where cname=''',curs3.data{1},''''];
curs1=exec(conn,sqlquery1);
curs1=fetch(curs1);
display(curs1);
%t=uint16(curs1.data{1});
t=num2str(curs1.data{1});
display(t);
display(strcmp(t,answer1(1)));
display(answer1(1));
delete('details.mat');
p=curs.data{1};
save('details.mat','p','t1');
if strcmp(t,answer1(1))
    %url = 'http://192.168.0.100:8080/shot.jpg';
    %ss  = imread(url);
    %pause(3);
    %fh = image(ss);
    %ss  = imread(url);
    %set(fh,'CData',ss);
    %imshow(ss);
    vid=videoinput('winvideo',1,'YUY2_320x240');
    hImage=image(zeros(320,180,3),'Parent',handles.axes1);
    preview(vid,hImage);
    set(vid,'ReturnedColorSpace','RGB');
    pause(2);
    im=getsnapshot(vid);
    %im =imread('C:\Users\NarsiReddy\Desktop\PCA_LDA\libsvm\group7.jpg');
    test_group(im);
    stoppreview(vid);
else
    display('Faculty ID is invalid');
end
close(conn);





% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
conn=database('project','project','project');
prompt = {'Enter your rollnumber'};
title = 'Input';
dims = [1 35];
answer1 = inputdlg(prompt,title,dims);
s=strcat('select * from attendance where rollnumber=''',answer1{1},'''');
curs=exec(conn,s);
curs=fetch(curs);
display(curs.data);
m=['ROLLNUMBER  ','        DATE            ','     DAY         ','P1 ','P2 ','P3 ','P4 ','P5 ','P6 ','P7'];
s1=' ';
[t s]=size(curs.data(:,1));
for i=1:t
    s1=' ';
    for j=1:10
        s1=strcat(s1,curs.data(i,j),{' '});
    end
    m=[m;s1];
end
msgbox(m,'Attendance');
%set(h,'position',[100 400 250 250]);
close(conn);
