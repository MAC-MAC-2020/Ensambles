%% Plot constantly active neurons
function plot_constantneurons(register_neurons,footprints,ensayo)

plotfoots = permute(footprints,[3,2,1]);

centroid_active_neuron = register_neurons.active_neuron_centroid;
% Sacar centroides
centroid_active_neuron = centroid_active_neuron{ensayo};
centroid_active_neuron_logical = centroid_active_neuron(:,1) > 0;
% Sacar footprints constantemente activos
footprint_ni = plotfoots{ensayo};
foot_active_neuron(:,:,:) = footprint_ni(centroid_active_neuron_logical,:,:);
% Los footprint que estuvieron constantemente activos se les suma 10
foot_active_neuron(foot_active_neuron(:,:,:) > 0) = 10;
% Se permuta la matriz para dejar cada frame en Z
foot_active_neuron = permute(foot_active_neuron,[3,2,1]);
footprint_ni = permute(footprint_ni,[3,2,1]);
% Junta todos los footprints (constantemente activos y todos en genereal). 
all_spatial_footprint = cat(3,footprint_ni,foot_active_neuron);

frame_final = sum(all_spatial_footprint,3);

frame_final(frame_final >= 10) = 10;
frame_final(frame_final < 10 & frame_final > 0) = 2;

constantly_active_neurons = register_neurons.constantly_active_neurons;
percent_sessions = register_neurons.percent_sessions;
n = constantly_active_neurons(ensayo);
neurons_each_session = register_neurons.neurons_each_session;
N = neurons_each_session(ensayo);

imagesc(frame_final)
percent = num2str(percent_sessions);
% percent = percent(1:5); % seleccionar solo 2 cifras significativas 
str =  {{['Neuronas activas en el ' percent '%' ' de las sesiones / n = ' num2str(n)]},['Total de neuronas en la sesion / N = ' num2str(N)]};
text(1,30,str{1},'Color','white','FontWeight','bold');
text(1,10,str{2},'Color','red','FontWeight','bold');
colormap hot
axis square





end
