close all;
clear all;

%Loads the JPG image into the image object
%Change the filename of the image used here:

im = imread('car6.jpg');


%Resizes image to be 480xNaN resolution, where NaN can be any width, so
%that it's easier to work with

im = imresize(im, [480 NaN]);
im1=im;


%Converts image to grayscale. 
imgray = rgb2gray(im);

%imshow(im);
%imshow(imgray);

%Applies a threshold function to the image
threshold = graythresh(im);
disp(threshold);
imbin =im2bw(im,threshold);

%figure; imshow(imbin);

%Applies sobel edge filter to the image
im = edge(imgray, 'sobel');

figure; imshow(im)

%imshow(im);

im = imdilate(im, strel('rectangle',[4 4]));

figure; imshow(im)

im = imfill(im, 'holes');

%figure;imshow(im)

im = imerode(im, strel('diamond',10));

%figure;imshow(im)

Iprops=regionprops(im,'BoundingBox','Area', 'Image');
area = Iprops.Area;
count = numel(Iprops);
maxa= area;
boundingBox = Iprops.BoundingBox;

for i=1:count
   if maxa<Iprops(i).Area
       maxa=Iprops(i).Area;
       boundingBox=Iprops(i).BoundingBox;
   end
end    

%all above step are to find location of number plate

im = imcrop(imbin, boundingBox);
%figure; imshow(im1);


%resize number plate to 240 NaN, so that it's bigger
im = imresize(im, [240 NaN]);

%figure; imshow(im);


%clear dust
im = imopen(im, strel('rectangle', [4 4]));

%figure; imshow(im);


%remove some object if it width is too long or too small than 500
im = bwareaopen(~im, 500);
%%%get width
 [h, w] = size(im);
% Iprops=regionprops(im,'BoundingBox','Area', 'Image');
% image = Iprops.Image;
% count = numel(Iprops);
% for i=1:count
%    ow = length(Iprops(i).Image(1,:));
%    if ow<(h/2) 
%         im = im .* ~Iprops(i).Image;
%    end
% end  

figure; imshow(im1);
figure; imshow(im);


%read letter
Iprops=regionprops(im,'BoundingBox','Area', 'Image');
count = numel(Iprops);

noPlate=[]; % Initializing the variable of number plate string.

for i=1:count
   ow = length(Iprops(i).Image(1,:));
   oh = length(Iprops(i).Image(:,1));
   if ow<(h/2) & oh>(h/3)
       letter=readLetter(Iprops(i).Image); % Reading the letter corresponding the binary image 'N'.
       %figure; imshow(Iprops(i).Image);
       noPlate=[noPlate letter]; % Appending every subsequent character in noPlate variable.
   end
end

fh=msgbox(noPlate, 'Number plate is:','help');
object_handles = findall(fh);
set(object_handles(6), 'FontSize', 20);
