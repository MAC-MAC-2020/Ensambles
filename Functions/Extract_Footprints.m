function Extract_Footprints(data_archivo,path_name,file_id,number_id,Params)
%% Extrae las huellas de las celulas.

% Corre dos funciones: 1 para sacar los centroides y 2 para sacar los
% footprints de cada imagen
% 1.- Extract_Centroids
% 2.- footprint

% output

% Guarda un archivo con las huellas de cada imagen. le agrega
% "_footprint_0n" al nombre del archivo original y lo guarda en la carpeta
% de origen. (Detalles en funcion "footprint")

%% Moises AC 02.dic.19

%% Funcion principal
% Extraer datos
size_neuron = Params.size_neuron;
plot_footprint = Params.plot_footprint;
plot_all_footprint = Params.plot_all_footprint;
for i = 1:length(data_archivo)

Datos = importdata(data_archivo{i});

% Select data
imax = Datos.imax;
pixh = Datos.pixh;
pixw = Datos.pixw;
seedsfn = Datos.seedsfn;

centroids = Extract_Centroids(pixh,pixw,seedsfn);
footprints = footprint(imax,centroids,size_neuron);%,plot_footprint,plot_allfootprint);

%% plot footprints
plotfoots = permute(footprints,[3,2,1]);
% plot footprint one by one
if plot_footprint == 1     
for ii = 1:length(centroids)   
imagesc(plotfoots(:,:,ii))
hold on
axis square
pause(0.1)
end
elseif plot_footprint == 0
end

% plot all footprint 
if plot_all_footprint == 1
SF = sum(plotfoots,3);
imagesc(SF)
axis square
elseif plot_all_footprint == 0
end
%%
file_name = [file_id{i} '_footprints' '_0' num2str(number_id(i))];
save([path_name, file_name], 'footprints')

clear centroids
end
disp('"Extract Footprints - Done"')