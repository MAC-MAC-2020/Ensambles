clear, clc
%% ENSEMBLES ANALYSIS %%

%% Moises AC 07.ago.2019
%% Select all files
[file_name, path_name] = uigetfile('*.mat', 'Select coordinates file', 'MultiSelect', 'on');
%data_archivo = strcat(path_name,file_name);

% Params (1)
Ensayos = 16; % This value has to be the same in all sessions
Sesiones = 51;
% Params (2)
Umbral = 2.5;

%% Number of Neurons 
% [Number_Neurons,AverNumNeurons] = Numero_de_Neuronas(Ensayos,Sesiones,file_name,path_name);
%% Detect significant calcium events 
% sig_events = sigevent(Umbral,file_name,path_name); 
%% Similitude Cosine
% [simcosine,Average_simcosine,All_Similitudes] = simcosine(Ensayos,Sesiones,file_name,path_name);
%% Extract Footprints of imax
data_archivo = strcat(path_name,file_name);

% Indicate file id for name files
file_id = file_name;
for i = 1:length(file_name)
file_id{i} = file_name{i}(1: end - 4);
end
number_id = 1:length(data_archivo);

for i = 1:length(data_archivo)
    
Datos = importdata(data_archivo{i});
% Select data
imax = Datos.imax;
pixh = Datos.pixh;
pixw = Datos.pixw;
seedsfn = Datos.seedsfn;

[y, x] = ind2sub([pixh, pixw], seedsfn);
centroids(:,1) = x;
centroids(:,2) = y;

% imagesc(imax)
% hold on
% plot(x,y,'o r')
% axis square

size_neuron = 5;
plot_footprint = 0;
plot_allfootprint = 1;

footprints = footprint(imax,centroids,size_neuron,plot_footprint,plot_allfootprint);

save([path_name, [file_id{i} '_footprints' '_0' num2str(number_id(i))]], 'footprints')
clear centroids
end
disp('done')
%% All Registered Projections from CELL-REGISTER
% This function plots the projections of all the cells for all the
% sessions. Green cells are those who were active in all sessions.  
% Cell All_registered_projections contains all matrix of all sessions. 

% Load files for only extract names.
data_archivo = strcat(path_name,file_name);
% Indicate file id for name files
file_id = file_name;
for i = 1:length(file_name)
file_id{i} = file_name{i}(1: end - 4);
end
number_id = 1:length(data_archivo);

% Load files manual; "aligned_data_struct" and "cell_registered_struct" from "cell-register" algorithm 
spatial_footprints = aligned_data_struct.spatial_footprints; 
cell_to_index_map = cell_registered_struct.cell_to_index_map;
figures_directory = aligned_data_struct.figures_directory;
figures_visibility = 'on';
%varargin

All_registered_projections = All_registered_projections(spatial_footprints,cell_to_index_map,figures_directory,figures_visibility);
for i = 1:length(All_registered_projections)
     All_registered_projections{i} = sum(All_registered_projections{i},3);
end

for j = 1:length(All_registered_projections)
    imax = All_registered_projections{j};
    
    [row , col] = find(imax == 1);
    centroids(:,1) = col;
    centroids(:,2) = row;
    
    size_neuron = 10;
    plot_footprint = 0;
    plot_allfootprint = 0;

     footprints = footprint(imax,centroids,size_neuron,plot_footprint,plot_allfootprint);
     %footprints = imax; 
   save([path_name, [file_id{j} '_footprints_CELL-REGISTER' '_0' num2str(number_id(j))]], 'footprints')
   clear centroids
end

disp('done')
% 

%% Similitude Map

%Configuracion inicial
% MAPA_DE_SIMILITUD = 'MAPA_DE_SIMILITUD';% Nombrar archivo de salida
% %Cargar archivo
% [Datos,Path] = LoadFile('Cargar archivo de manera interactiva');
% Rasterbin = Datos; %Selecciona la variable de interes
% %Utiliza la funcion 'mapsim'
% mapa_similitud = mapsim(Rasterbin);


%%
return
%% Colormaps
maximo = max(max(sigfn));
normsig = (sigfn/maximo); 
DesEst = std(std(normsig));
DesEst = DesEst*2.5;
[r,c] = size(sigfn);
largo = r*c;
for i = 1:largo

    if normsig(i) <= DesEst
        normsig(i) = 0;
    end
    
end
% close all
figure(1)
%subplot(1,2,1)
imagesc(sigfn)
colorbar
figure(2)
%subplot(1,2,2)
imagesc(normsig)
colorbar
colorbar('Ticks',[0,1],'TickLabels',{'min','max'})
colormap(jet)
disp('done Colormaps')


%% Promedio
Promedio_sigfn = mean(sigfn);

Promedio_normsig = mean(normsig);

figure(1)
subplot(1,2,1)
plot(Promedio_sigfn)
subplot(1,2,2)
plot(Promedio_normsig)



