function footprints = footprint(imax,centroids,size_neuron)%,Plotfootprint,Plotallfootprint)
%% Extrae formalmente los footprints 

% inputs 

% imax = proyeccion maxima. Matriz n X m donde estan las huellas de las neuronas
% centroids = coordenadas (x,y) de los centroides
% size_neuron = tamano de neurona (radio). 

% outputs 

%footprints = matriz de m X n X z, donde, m = footprint de la e-sima neurona.
%n,z = tamano de la proyeccion maxima. 
%(Los datos se acomodan de esta manera para entrar a Cell-Reg.

%% Moises AC 02.dic.19

%%
x = centroids(:,1);
footprints = zeros(size(imax,1),size(imax,2),length(x));
for i = 1:length(x) 

I = imax;
imageSize = size(I);
ci = [centroids(i,2),centroids(i,1),size_neuron];     % center and radius of circle ([c_row, c_col, r])
[xx,yy] = ndgrid((1:imageSize(1))-ci(1),(1:imageSize(2))-ci(2));
mask = ((xx.^2 + yy.^2)<ci(3)^2);
croppedImage = zeros(size(I));
croppedImage(:,:) = I(:,:).*mask;

footprints(:,:,i) = croppedImage;
end

footprints = permute(footprints,[3,2,1]);
%% plot footprints

% plotfoots = permute(footprints,[3,2,1]);
% 
% plot footprint one by one
% if Plotfootprint == 1     
% for ii = 1:length(x)   
% imagesc(plotfoots(:,:,ii))
% hold on
% axis square
% pause(0.1)
% end
% elseif Plotfootprint == 0
% end
% 
% % plot all footprint 
% if Plotallfootprint == 1
% SF = sum(plotfoots,3);
% imagesc(SF)
% axis square
% elseif Plotallfootprint == 0
% end


end

