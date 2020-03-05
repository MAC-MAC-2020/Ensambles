%% Comparar trayectorias contra trayectorias (o estimulos)
% Cargar final_results_ProportionCell. Donde esta la variable "active_neuron_centroid" donde estan los centroides de las neuronas activas
% Manualmente cambiar nombres de final_results_ProportionCell, al final con L para
% luz y T para tono 
active_neuron_centroid_Luz = final_results_CellProportion_L.all_trajectory_register_neurons.active_neuron_centroid;
active_neuron_centroid_Tono = final_results_CellProportion_T.all_trajectory_register_neurons.active_neuron_centroid;
active_neuron_centroid_Luz_Tono = vertcat(active_neuron_centroid_Luz,active_neuron_centroid_Tono);

% Extraer los footsprint de luz y tono
footprints_Luz = final_results_CellProportion_L.footprints;
footprints_Tono = final_results_CellProportion_T.footprints;
footprints_LUZ_TONO = vertcat(footprints_Luz,footprints_Tono);

%% Correr registerneurons para ver las neuronas que se comparten 
th = 5;
percent_sessions = 0.8;
[all_trajectory_register_neurons_LUZ_TONO] = registerneurons(active_neuron_centroid_Luz_Tono,th,percent_sessions);

save('all_trajectory_register_neurons_LUZ_TONO','all_trajectory_register_neurons_LUZ_TONO','-v7.3')
%% Plots de neuronas
% Select data to plot
register_neurons = all_trajectory_register_neurons_LUZ_TONO; %
close all
for i = 1:length(footprints_LUZ_TONO)
    figure(i)
    plot_constantneurons(register_neurons,footprints_LUZ_TONO,i)
end