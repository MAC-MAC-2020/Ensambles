clear,clc,close all
tic
%% Proporcion de celulas presentes en diferentes ensayos
% input:
% Cargar varios archivos "data_processed" de min1pipe para para correr CellReg
% Este script anida varias funciones importantes, entre ellas:
% (CellReg_MAC/Extract_Footprints/footprint) y todo el paquete de CellReg.
%% Moises AC 02.dic.2019
% Solo se agregaron comentarios ---MAC 08.ene.2020
%% Informar que tipo de videos se van a cargar
data_processed_files = 1; % 1 = yes 0 = no
behaviour_videos = 1; % 1 = yes 0 = no
%% Cargar Archivos
[file_name, path_name, data_archivo, file_id, number_id] = LoadFiles;

% Only extract  data_processed files
half_of_files = (length(data_archivo)/2); % cuenta cuantos archivos de data_processed hay
if data_processed_files == 1
    data_archivo_data_processed = data_archivo(half_of_files+1:end);
    file_id_data_processed = file_id(half_of_files+1:end);
    number_id_data_processed = number_id(1:half_of_files);
else
    data_archivo_data_processed = data_archivo;
    file_id_data_processed = file_id;
    number_id_data_processed = number_id;
end

% Only extract behaviour videos

if behaviour_videos == 1
    data_archivo_behav_videos = data_archivo(1:half_of_files);
end
%% Parametros
% Extract footprints Params
Params.size_neuron = 5; % radio de la celula para el footprint
Params.plot_footprint = false; % Grafica todos los footprint uno por uno   
Params.plot_all_footprint = false; % Grafica todos los footprint en una sola imagen
% Stage 1 Load Sessions
Params.path_name = path_name;
Params.figures_visibility = 'off';
Params.microns_per_pixel = 1;
% Stage 2 FOV alignment
Params.alignment_type = 'Non-rigid'; % either 'Translations', 'Translations and Rotations' or 'Non-rigid'
Params.maximal_rotation = 45; % in degrees - only relevant if 'Translations and Rotations'
Params.transformation_smoothness = 0.5; % levels of non-rigid FOV transformation smoothness (range 0.5-3)
Params.reference_session_index = 1;
% Stage 3 Probabilistic Model
Params.maximal_distance = 12; % cell-pairs that are more than 12 micrometers apart are assumed to be different cells
% Stage 4 Initial Cell Registration 
Params.initial_registration_type = 'Centroid distance';% either 'Spatial correlation', 'Centroid distance', or 'best_model_string';
Params.Correlation_Threshold = 0.65; % Default 0.65. If de initial registration type is Spatial correlation
Params.Distance_Threshold_Microns = 5; % Default 5. If de initial registration type is Centroid distance
% Stage 5 Final Cell Registration
Params.registration_approach = 'Simple threshold'; % either 'Probabilistic' or 'Simple threshold'
Params.model_type = 'Centroid distance'; % either 'Spatial correlation' or 'Centroid distance'
Params.Final_p_same_threshold = 0.5; % Default 0.5. Only relevant if probabilistic approach is used
Params.Final_Correlation_Threshold = 0.65; % Default 0.65. If de initial registration type is Spatial correlation
Params.Final_Distance_Threshold_Microns = 5; % Default 5. If de initial registration type is Centroid distance
%% Segmentar imagen en footprints
% This function extract footprints of several files
footprints = Extract_Footprints(data_archivo_data_processed,path_name,file_id_data_processed,number_id_data_processed,Params);
%% CellReg
% Load data

footprint_file_name = file_id_data_processed;
for i = 1:length(file_id_data_processed)
    footprint_file_name{i} = [file_id_data_processed{i} '_footprints' '_0' num2str(number_id_data_processed(i)) '.mat'];
end
footprint_data_archivo = strcat(path_name,footprint_file_name);
% Run CellReg_MAC
file_name_CellReg = CellReg_MAC(footprint_data_archivo,Params);

%% Detectar estimulo
if behaviour_videos == 1
    all_stimulus = StimDetect(data_archivo_behav_videos,path_name);
else
    all_stimulus = StimDetect;
end
%% Neuronas activas durante el estimulo y trayectoria
% Evaluar si se corrio CellReg_MAC  
flag = exist('file_name_CellReg','var');

if flag == 1
data_archivo_CellReg = strcat(path_name,file_name_CellReg);
cell_registered_struct = importdata(data_archivo_CellReg);
end

all_neurons_active_stimulus = cell(length(data_archivo_data_processed),1);
all_neurons_active_trajectory = cell(length(data_archivo_data_processed),1);
for i = 1:length(data_archivo_data_processed) % Sacar variables sigfn, pixh, pixw, seedsfn
    Datos = importdata(data_archivo_data_processed{i});
    
    sigfn = Datos.sigfn;
    pixh = Datos.pixh;
    pixw = Datos.pixw;
    seedsfn = Datos.seedsfn;
    
    stimulus = all_stimulus{i};
    
    if flag == 1
    centroids_corr = cell_registered_struct.centroid_locations_corrected;%Extraer centroides corregidos de CellReg 
    centroids =  centroids_corr{i}; 
    else 
   centroids = Extract_Centroids(pixh,pixw,seedsfn);
    end
    
    % Neuronas activas durante el estimulo
    neurons_active_stimulus = neuactiestimulo(stimulus,sigfn,centroids);
    all_neurons_active_stimulus{i} = neurons_active_stimulus;
    % Neuronas activas durante la trayectoria
    neurons_active_trajectory = neuactitrayectoria(stimulus,sigfn,centroids);
    all_neurons_active_trajectory{i} = neurons_active_trajectory;
end
disp('"Active neurons in stimulus/trajectory done"')
%% Register neurons: saca las celulas que estan presentes en cada ensayo o sesion (en prncipo es lo mismo que cell-reg)
data_archivo = strcat(path_name,file_name_CellReg);
cell_registered_struct = importdata(data_archivo);
th = 5; % distancia maxima para decir que dos celulas son iguales
percent_sessions = 0.8; % Porcentaje de sesiones en la que esta una neurona
[all_trail_register_neurons] = registerneurons(cell_registered_struct,th,percent_sessions);
[all_stimulus_register_neurons] = registerneurons(all_neurons_active_stimulus,th,percent_sessions);
[all_trajectory_register_neurons] = registerneurons(all_neurons_active_trajectory,th,percent_sessions);
disp('"Register neurons done"')
%% Prepare data to save of ProportionCell
final_results_CellProportion.all_neurons_active_stimulus = all_neurons_active_stimulus;
final_results_CellProportion.all_neurons_active_trajectory = all_neurons_active_trajectory;
final_results_CellProportion.all_stimulus = all_stimulus;
final_results_CellProportion.Params = Params;
final_results_CellProportion.all_trail_register_neurons = all_trail_register_neurons;
final_results_CellProportion.all_stimulus_register_neurons = all_stimulus_register_neurons;
final_results_CellProportion.all_trajectory_register_neurons = all_trajectory_register_neurons;
final_results_CellProportion.footprints = footprints;

% Save final results
WorkFolder = cd; cd(path_name);
save(['final_results_CellProportion-' date '.mat'],'final_results_CellProportion','-v7.3');
cd(WorkFolder)
disp('"Save done"')
toc
%% Plots de neuronas
% Select data to plot
register_neurons = all_trajectory_register_neurons; %
close all
for i = 1:length(footprints)
    figure(i)
    plot_constantneurons(register_neurons,footprints,i)
end


%% Matrix correlation
return
% calculating correlations between the centroid projections for all pairs of sessions:
name = 'SessionPRUEB';
number_of_sessions = 5;

footprints_projections_corrected = aligned_data_struct.footprints_projections_corrected;


if number_of_sessions>2
    all_projections_correlations=zeros(number_of_sessions,number_of_sessions);
    for n=1:number_of_sessions
        all_projections_correlations(n,n)=1;
        for k=n+1:number_of_sessions
            all_projections_correlations(n,k)=corr2(footprints_projections_corrected{n},footprints_projections_corrected{k});            
            all_projections_correlations(k,n)=all_projections_correlations(n,k);
        end
    end
else
    %all_projections_correlations=maximal_cross_correlation;
end

filename = 'all_projections_correlations';

clims = [0 1];
% colormap(jet)
imagesc(all_projections_correlations,clims)
save([filename name],'all_projections_correlations')







