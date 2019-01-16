% Example function call
% convertToAvi([pwd,'\'],'Movie 7. Visualising CM-EVs Associating with the Pericardial Wall.avi','MPEG-4',24);

function convertToAvi(pName,fName,format,framerate)
trueColor = false;

% Need to load image stack from filenames
[~,~,ext] = fileparts(fName);

if strcmpi(ext,'.tif')
    info = imfinfo(strcat([pName,fName]));
    
    if strfind(info(1).ColorType,'truecolor') == 1
        trueColor = true;
    end
    
    for i = 1:numel(info)
        if trueColor
            im(:,:,:,i) = imread(strcat([pName,fName]),i);
        else
            im(:,:,i) = imread(strcat([pName,fName]),i);
        end
    end
    
elseif strcmpi(ext,'.avi')
    trueColor = true;
    v = VideoReader([pName,fName]);
    
    i=1;
    while v.hasFrame
       im(:,:,:,i) = readFrame(v);
       i = i+1;
    end    
end

[~,fName,~] = fileparts(fName);

if nargin >= 4
    fName = strcat([fName,'_',num2str(framerate),'fps']);
end

if numel(findstr(format,'MPEG-4')) ~= 0
    v = VideoWriter(strcat([pName,fName,'.mp4']),'MPEG-4');
    v.Quality = 100;
elseif numel(findstr(format,'Motion JPEG AVI')) ~= 0
    v = VideoWriter(strcat([pName,fName,'.avi']),'Motion JPEG AVI');
elseif numel(findstr(format,'ARCHIVAL')) ~= 0
    v = VideoWriter(strcat([pName,fName]),'ARCHIVAL');
elseif numel(findstr(format,'Uncompressed AVI')) ~= 0
    v = VideoWriter(strcat([pName,fName]),'Uncompressed AVI');
elseif numel(findstr(format,'MOTION JPEG 2000')) ~= 0
    v = VideoWriter(strcat([pName,fName]),'MOTION JPEG 2000');
end

if nargin >= 4
    v.FrameRate = framerate;
end

open(v);

if trueColor
    for i = 1:size(im,4)
        writeVideo(v,im(:,:,:,i));
    end
else
    for i = 1:size(im,3)
        writeVideo(v,im(:,:,i));
    end
end

close(v)