I=imread('moon.tif');

[x,y]=size(I);

X=1:x;

Y=1:y;

[xx,yy]=meshgrid(Y,X);

i=im2double(I);

figure;mesh(xx,yy,i);

colorbar

figure;imshow(i)
