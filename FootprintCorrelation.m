clear,clc,close all
%% Matriz de Correlacion de Huellas Celulares
% Modificacion del codigo CellReg para cambiar los parametros con codigo y
% no tener que utilizar el GUI

% Requiere la Funcion: CellReg_MAC

%% Moises AC 02.dic.2019
%% Cargar Archivos  
[file_name, path_name, data_archivo, file_id, number_id] = LoadFiles;
%% Parametros
Params.size_neuron = 5; % radio de la celula para el footprint
Params.plot_footprint = false; % Grafica todos los footprint uno por uno   
Params.plot_all_footprint = false; % Grafica todos los footprint en una sola imagen
% Stage 1 Load Sessions
Params.path_name = path_name;
Params.figures_visibility = 'on';
Params.microns_per_pixel = 1;
% Stage 2 FOV alignment
Params.alignment_type = 'Non-rigid'; % either 'Translations', 'Translations and Rotations' or 'Non-rigid'
Params.maximal_rotation = 30; % in degrees - only relevant if 'Translations and Rotations'
Params.transformation_smoothness = .5; % levels of non-rigid FOV transformation smoothness (range 0.5-3)
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
Extract_Footprints(data_archivo,path_name,file_id,number_id,Params);
%% CellReg
% Load data
footprint_file_name = file_id;
for i = 1:length(file_id)
footprint_file_name{i} = [file_id{i} '_footprints' '_0' num2str(number_id(i)) '.mat'];
end
footprint_data_archivo = strcat(path_name,footprint_file_name);
% Run CellReg_MAC
CellReg_MAC(footprint_data_archivo,Params)

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







