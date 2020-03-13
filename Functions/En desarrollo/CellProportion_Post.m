2%% Comparar trayectorias contra trayectorias (o estimulos)
% Cargar final_results_ProportionCell. Donde esta la variable "active_neuron_centroid" donde estan los centroides de las neuronas activas
% Manualmente cambiar nombres de final_results_ProportionCell, al final con L para
% luz y T para tono 
clear
name_save = 'all_trajectory_register_neurons_LUZ_TONO';

file_name_1 = 'final_results_CellProportion_Luz correcto Apren S34R6-05-Mar-2020';
file_name_2 = 'final_results_CellProportion_Tono correcto Apren S34R6-05-Mar-2020';

load (file_name_1)
final_results_CellProportion_L = final_results_CellProportion;
load(file_name_2)
final_results_CellProportion_T = final_results_CellProportion;

% Extraer centroides de celulas que no pertenecen al ensamble luz y tono
active_neuron_centroid_Luz_todas = final_results_CellProportion_L.all_neurons_active_trajectory;
active_neuron_centroid_Tono_todas = final_results_CellProportion_T.all_neurons_active_trajectory;
active_neuron_centroid_Luz_Tono_todas = vertcat(active_neuron_centroid_Luz_todas,active_neuron_centroid_Tono_todas);
% Extraer los centroides activos que representan el ensamble para luz y tono
active_neuron_centroid_ensamble_Luz = final_results_CellProportion_L.all_trajectory_register_neurons.active_neuron_centroid;
active_neuron_centroid_ensamble_Tono = final_results_CellProportion_T.all_trajectory_register_neurons.active_neuron_centroid;
active_neuron_centroid_ensamble_Luz_Tono = vertcat(active_neuron_centroid_ensamble_Luz,active_neuron_centroid_ensamble_Tono);

% Extraer los footsprint que representan el ensamble para luz y tono
footprints_Luz = final_results_CellProportion_L.footprints;
footprints_Tono = final_results_CellProportion_T.footprints;
footprints_ensamble_LUZ_TONO = vertcat(footprints_Luz,footprints_Tono);

%% Correr registerneurons para ver las neuronas que se comparten 
th = 5;
percent_sessions = 0.8;
[register_neurons_post] = registerneurons(active_neuron_centroid_ensamble_Luz_Tono,th,percent_sessions);

%% Extraer centroides activos de celulas que se comparten 
active_neuron_centroid_compartidas = register_neurons_post.active_neuron_centroid;

%% Save results
save(name_save,'register_neurons_post','-v7.3')

RGB_maps
% % Plots de neuronas
% % Select data to plot
% register_neurons = register_neurons_post; %
% close all
% for i = 1:length(footprints_ensamble_LUZ_TONO)
%     figure(i)
%     plot_constantneurons(register_neurons,footprints_ensamble_LUZ_TONO,i)
% end






