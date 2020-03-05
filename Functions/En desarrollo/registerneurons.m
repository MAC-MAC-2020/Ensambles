 function [register_neurons] = registerneurons(centroides_a_comparar,threshold,percent_sessions)

% Extraer informacion de interes cell_registered
% tip = class(centroides_a_comparar);
tip = isstruct(centroides_a_comparar);
if tip == 1
centroid_locations_corrected = centroides_a_comparar.centroid_locations_corrected;
else
centroid_locations_corrected = centroides_a_comparar;
end
%spatial_footprints_corrected = cell_registered_struct.spatial_footprints_corrected;
num_sesions = length(centroid_locations_corrected);

%% Number of neurons in each session
   neurons_each_session = zeros(length(centroid_locations_corrected),1);
for l = 1:length(centroid_locations_corrected)
   neurons_each_session(l) = length(centroid_locations_corrected{l});
end

%% Part 1: Position of all neurons
all_neurons_position = cell(num_sesions-1); % Preallocate memory
all_distances = cell(num_sesions-1);
for i = 1:length(centroid_locations_corrected)-1
    % Extract centroids A
    centroides_A = centroid_locations_corrected{i};
    h = i+1;  
    for j = h:length(centroid_locations_corrected)
        col = j-1;
        % Extract centroids B
        centroides_B = centroid_locations_corrected{h};
        % Calculate distance
        distance_ni = pdist2(centroides_A,centroides_B);
        tamanoF = size(distance_ni,1);
        tamanoC = size(distance_ni,2);
        % celulas mas cercanas para las filas
        minimo_filas1 = min(distance_ni,[],2);
        minimo_filas2 = minimo_filas1<=threshold;
        minimo_filas3 =  minimo_filas1(minimo_filas2);
        indices_coordenadas = zeros(length(minimo_filas3),1);
        for k = 1:length(minimo_filas3)
            % Saldra error si un numero minimo se repite
            indices_coordenadas(k,1) = find(distance_ni == minimo_filas3(k));
        end
        [coor_cell_filas(:,1),coor_cell_filas(:,2)] = ind2sub([tamanoF tamanoC],indices_coordenadas);
        
        % celulas mas cercanas para las columnas
        minimo_columnas1 = min(distance_ni);
        minimo_columnas2 = minimo_columnas1<=threshold;
        minimo_columnas3 =  minimo_columnas1(minimo_columnas2);
        indices_coordenadas_columnas = zeros(length(minimo_columnas3),1);
        for k = 1:length(minimo_columnas3)
            indices_coordenadas_columnas(k,1) = find(distance_ni == minimo_columnas3(k));
        end
        [coor_cell_columnas(:,1),coor_cell_columnas(:,2)] = ind2sub([tamanoF tamanoC],indices_coordenadas_columnas);
        
        fila = coor_cell_filas(:,1);
        columna = coor_cell_columnas(:,1);
        columna_unique = unique(columna);
        
        same_neurons = zeros(length(columna_unique),1);
        for k = 1:length(same_neurons)
            same_neurons(k) = find(fila == columna_unique(k));
        end
        position_same_neurons = zeros(length(same_neurons),2);
        for k = 1:length(same_neurons)
            position_same_neurons(k,:) = coor_cell_filas(same_neurons(k),1:2);
        end
       all_neurons_position{i,col} =  position_same_neurons;
       all_distances{i,col} = distance_ni;
       h = h+1;  
       clear 'coor_cell_filas' 'coor_cell_columnas'
    end
end

%% Part 2: Index Map
% Index map of cells presents in several essay
sesionuno(:,1) = 1:neurons_each_session(1);
index_map = zeros(neurons_each_session(1),length(centroid_locations_corrected)); 
index_map(:,1) = sesionuno;
% selec_raw_inicial = 1;
for i = 1:length(all_neurons_position) % avance en filas
    for j = 1:length(all_neurons_position) % avance en columnas
        col = j+1; % Indica la sesion (o columna) que se esta indexando.
        is_empty = isempty(all_distances{i,j}); % Si no hay datos quiere decir que es momento de brincar a la siguiente fila (sesion). i aumenta de valor
        if is_empty == 0
            index_1 = all_neurons_position{i,j};
%             select_raw_final = length(index_map);
            for k = 1:length(index_1)
                delete_repetition = index_map(:,col) == index_1(k,2);
                sum_delete_repetition = sum(delete_repetition);
                if sum_delete_repetition == 0
                map_index_raw = (index_map(:,i) == index_1(k));
                index_map(map_index_raw,col) = index_1(k,2);
%                 elseif sum_delete_repetition ~= 0
%                     sum_delete_repetition
%                     pause
                end
            end
        % Aumento de tamaño de index_map
        elseif is_empty == 1 % Cuando i aumente de valor, abra un [], y en index_map, en la i actual se buscan los valores que no esten en esa columna y crece de tamano index_map, tanto como valores en esa columna hayan faltado
            index_2 = index_map(:,i);
            length_map_index = length(index_map);
            contador = 0;
            for k = 1:neurons_each_session(i) % Si al buscar un valor k en index_2 no existe entonces ese valor se coloca en index_map en la fila-columna donde termina la sesion (por ejemplo, cuando i=2, en la fila donde termina la sesion 1 y en la columna 2, que es de la sesion 2). 
                index_ni = index_2(:) == k; 
                suma = sum(index_ni);
                if suma == 0
                    contador = contador + 1; % Al tamano actual de map_index se le va sumando 1. 
                    index_map(length_map_index + contador,i) = k;
%                     increase_in_index_map = length(index_map) - length_map_index;
%                     selec_raw_inicial = (length(index_map) - increase_in_index_map)+1;
                end
            end
        end
    end
end
%% Part 3: Extract centroids of active cells
% Neuronas que se activaron por lo menos el 70% de los ensayos
sesion_act_sig = percent_sessions; 
neurons_actives = index_map ~= 0; % Neuronas que estuvieron actvas en cada sesion
neurons_actives = sum(neurons_actives,2); % numeo de sesiones que las neuronas estuvieron activas en 
sesion_act_sig = num_sesions*sesion_act_sig;
sesion_act_sig = ceil(sesion_act_sig);
neurons_active_significative = neurons_actives >= sesion_act_sig;
sum_neurons_active_significative = sum(neurons_active_significative);
total_neurons = sum(neurons_each_session);
% percent_of_neurons_active_in_sessions = (sum_neurons_active_significative/total_neurons)*100;

real_percent = (sesion_act_sig/num_sesions)*100; % Porcentaje real de activacion de las neuronas en las sesiones.  

active_neuron_centroid = cell(length(centroid_locations_corrected),1);
constantly_active_neurons = zeros(length(centroid_locations_corrected),1);
for i = 1:length(centroid_locations_corrected)
    centroid_corr_ni = centroid_locations_corrected{i}; % centroides de la sesion actual
    sesion_index_map  = index_map(:,i);
    ind_neuron_active = sesion_index_map(neurons_active_significative);
    ind_neuron_active(ind_neuron_active==0) = []; % indices de neuronas activas de la sesion actual
    centroids_NaN = NaN(length(centroid_corr_ni),2);
    centroids_NaN(ind_neuron_active,:) = centroid_corr_ni(ind_neuron_active,:);
    active_neuron_centroid{i} = centroids_NaN;
    
    % Sacar numero de neuronas activas el X% de las sesiones para cada sesion 
    numero_neurona_siempre_activas = centroids_NaN(:,1) > 0;
    sum_numero_neurona_siempre_activas = sum(numero_neurona_siempre_activas);
    constantly_active_neurons(i) = sum_numero_neurona_siempre_activas;
end

%% Prepare data for save
register_neurons.index_map = index_map;
register_neurons.all_neurons_position = all_neurons_position;
% register_neurons.spatial_footprints_corrected = spatial_footprints_corrected;
register_neurons.centroid_locations_corrected = centroid_locations_corrected;
register_neurons.percent_sessions = real_percent;
register_neurons.active_neuron_centroid = active_neuron_centroid;
% register_neurons.percent_neurons = percent_of_neurons_active_in_sessions;
register_neurons.neurons_each_session = neurons_each_session;
register_neurons.constantly_active_neurons = constantly_active_neurons;
register_neurons.total_neurons = total_neurons;
register_neurons.sum_neurons_active_significative  = sum_neurons_active_significative;
 register_neurons.all_distances = all_distances;
 end
