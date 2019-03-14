function varargout = image_processing(varargin)
% IMAGE_PROCESSING MATLAB code for image_processing.fig
%      IMAGE_PROCESSING, by itself, creates a new IMAGE_PROCESSING or raises the existing
%      singleton*.
%
%      H = IMAGE_PROCESSING returns the handle to a new IMAGE_PROCESSING or the handle to
%      the existing singleton*.
%
%      IMAGE_PROCESSING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGE_PROCESSING.M with the given input arguments.
%
%      IMAGE_PROCESSING('Property','Value',...) creates a new IMAGE_PROCESSING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before image_processing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to image_processing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help image_processing

% Last Modified by GUIDE v2.5 25-Oct-2018 16:51:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @image_processing_OpeningFcn, ...
                   'gui_OutputFcn',  @image_processing_OutputFcn, ...
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


% --- Executes just before image_processing is made visible.
function image_processing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to image_processing (see VARARGIN)

% Choose default command line output for image_processing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes image_processing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = image_processing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadvia.
function loadvia_Callback(hObject, eventdata, handles)
% hObject    handle to loadvia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.processed_via)
cla(handles.original_via)
set(handles.diagnosis,'String','');
[FileName,PathName]=uigetfile({'*.tif';'*.jpg';'*.png'},'Select image to upload');
 fullfilename=fullfile(PathName, FileName);
tic
image=imread(fullfilename);
axes(handles.original_via);
imshow(image);
handles.image=image;
t=toc;
set(handles.load_time,'string',num2str(t));
guidata(hObject, handles);

% --- Executes on button press in viaROI.
function viaROI_Callback(hObject, eventdata, handles)
% hObject    handle to viaROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.image;
cervix_crop=imcrop(handles.original_via);
handles.cervix_crop=cervix_crop;
f = waitbar(0.5,'Please wait, processing your data...');
tic
de_spec=Remove_specular_refl(cervix_crop);
handles.de_spec=de_spec;
waitbar(1,f,'Finishing');
axes(handles.preprocessed_via);
imshow(de_spec, 'InitialMag', 'fit')
t=toc;
set(handles.preproc_time,'string',num2str(t));
close(f)
guidata(hObject, handles);


% --- Executes on button press in process.
function process_Callback(hObject, eventdata, handles)
% hObject    handle to process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic
f = waitbar(0,'Please wait, processing your data...');
img_col=handles.gab_roi;
img_tex=handles.gab_rect;
%color features
waitbar(0.2,f,'Extracting color features');
color_feat=color_feature_fun(img_col);
%texture_Feat
waitbar(0.5,f,'Extracting texture features');
texture_feat=haralick_feature_fun(img_tex);
%gabor_via placeholders
gab_feat=[1,1,1];

all_feats=[texture_feat,gab_feat,color_feat];

%VIA features
via_feat=all_feats([11,16,31,3,2,28]);

%show features
 lab = double(rgb2lab(uint8(img_col)));
 b=lab(:,:,3);
 bimg=((b-min(min(b)))./(max(max(b))-min(min(b))));
 axes(handles.processed_via)
 imagesc(bimg);colormap(handles.processed_via,jet);caxis([0,1])
 set(gca,'ytick',[],'xtick',[])
 
 %classify
 waitbar(0.7,f,'Classifying image');
 model=handles.mdl_via;
[label,score]=predict(model,via_feat);
if label==0;
    diag='VIA negative';
elseif label==1;
        diag='VIA postive';
end
 set(handles.diagnosis,'string',diag,'FontSize',16,'FontWeight','bold')
 t=toc;
set(handles.proc_time,'string',num2str(t));
 close(f)
 guidata(hObject, handles);


% --- Executes on button press in gabor_seg.
function gabor_seg_Callback(hObject, eventdata, handles)
% hObject    handle to gabor_seg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic
f = waitbar(0.5,'Please wait, processing your data...');
[gab_roi,gab_rect]=gabor_segment(handles.de_spec);
waitbar(1,f,'Finishing');
handles.gab_roi=gab_roi;
handles.gab_rect=gab_rect;
axes(handles.gabor_via);
imshow(gab_roi, 'InitialMag', 'fit')
t=toc;
set(handles.gab_time,'string',num2str(t));
close(f)
guidata(hObject, handles);


% --- Executes on button press in loadvili.
function loadvili_Callback(hObject, eventdata, handles)
% hObject    handle to loadvili (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in viaclassifier.
function viaclassifier_Callback(hObject, eventdata, handles)
% hObject    handle to viaclassifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mdlsvm_via=uigetfile('*.mat');
viaclassifier=load(mdlsvm_via);
mdl_via=viaclassifier.mdlSVM;
handles.mdl_via=mdl_via;
guidata(hObject, handles);

% --- Executes on button press in viliclassifier.
function viliclassifier_Callback(hObject, eventdata, handles)
% hObject    handle to viliclassifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in viliROI.
function viliROI_Callback(hObject, eventdata, handles)
% hObject    handle to viliROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
