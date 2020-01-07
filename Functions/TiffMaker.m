
function [name]=TiffMaker(reg,NombreTiff)
[Dimension1,Dimension2,Dimension3] = size(reg);
name= strcat(NombreTiff, '.tif');
y=zeros(Dimension1,Dimension2);
for i=1:Dimension3
    y=y+double(reg(:,:,i));
    imwrite(double(reg(:,:,i)),name, 'WriteMode', 'append',  'Compression','none');
end
y=y/Dimension3;
imwrite(y, 'MediaImagen.tif','Compression','none');