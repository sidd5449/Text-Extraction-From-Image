a = imread("test.jpg");
b = imresize(a, 3);
I = im2gray(b);

figure
imshow(I)

% Run OCR on the image
results = ocr(I);

results.Text

BW = imbinarize(I);

figure
imshowpair(I,BW,"montage")

Icorrected = imtophat(I,strel("disk",15));

BW1 = imbinarize(Icorrected);

% Perform reconstruction and show binarized image.
marker = imerode(Icorrected,strel("line",10,0));
Iclean = imreconstruct(marker,Icorrected);

Ibinary = imbinarize(Iclean);

figure
imshowpair(Iclean,Ibinary,"montage")

BW2 = imcomplement(Ibinary);
figure
imshowpair(Ibinary,BW2,"montage")

results = ocr(BW2);

results.Text

results = ocr(BW2,CharacterSet="ABCDEFGHIJKLMOPQRSTUVWXYZ");

results.Text

% Use regionprops to find bounding boxes around text regions and measure their area.
cc = bwconncomp(Ibinary);
stats = regionprops(cc, ["BoundingBox","Area"]);

% Extract bounding boxes and area from the output statistics.
roi = vertcat(stats(:).BoundingBox);
area = vertcat(stats(:).Area);

% Show all the connected regions.
img = insertObjectAnnotation(I,"rectangle",roi,area ,"LineWidth",3);
figure;
imshow(img);

% Define area constraint based on the area of smallest character of interest.
areaConstraint = area == 2190;

% Keep regions that meet the area constraint.
roi = double(roi(areaConstraint,:));


% Show remaining bounding boxes after applying the area constraint.
img = insertShape(I,"rectangle",roi);
figure;
imshow(img);

