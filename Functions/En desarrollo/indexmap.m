%% Este script esta integrado en neuronsposition

clear

load 'cellRegistered_20200224_152502'
[all_neurons_position] = neuronsposition(cell_registered_struct);


centroid_locations_corrected = cell_registered_struct.centroid_locations_corrected;
% Number of total neurons
   total_neurons = zeros(length(centroid_locations_corrected),1);
for i = 1:length(centroid_locations_corrected)
   total_neurons(i) = length(centroid_locations_corrected{i});
end

% Index map of cells presents in several essay
sesionuno(:,1) = 1:total_neurons(1);
index_map = zeros(total_neurons(1),length(centroid_locations_corrected)); 
index_map(:,1) = sesionuno;
selec_raw_inicial = 1;
for i = 1:length(all_neurons_position) % avance en filas
    for j = 1:length(all_neurons_position) % avance en columnas
        col = j+1; % Indica la sesion (o columna) que se esta indexando.
        is_empty = isempty(all_neurons_position{i,j}); % Si no hay datos quiere decir que es momento de brincar a la siguiente fila (sesion). i aumenta de valor
        if is_empty == 0
            index_1 = all_neurons_position{i,j};
            select_raw_final = length(index_map);
            for k = 1:length(index_1)
                delete_repetition = index_map(selec_raw_inicial:select_raw_final,col) == index_1(k,2);
                sum_delete_repetition = sum(delete_repetition);
                if sum_delete_repetition == 0
                map_index_raw = (index_map(:,i) == index_1(k));
                index_map(map_index_raw,col) = index_1(k,2);
                end
            end
        % Aumento de tamaño de index_map
        elseif is_empty == 1 % Cuando i aumente de valor, abra un [], y en index_map, en la i actual se buscan los valores que no esten en esa columna y crece de tamano index_map, tanto como valores en esa columna hayan faltado
            index_2 = index_map(:,i);
            length_map_index = length(index_map);
            contador = 0;
            for k = 1:total_neurons(i) % Si al buscar un valor k en index_2 no existe entonces ese valor se coloca en index_map en la fila-columna donde termina la sesion (por ejemplo, cuando i=2, en la fila donde termina la sesion 1 y en la columna 2, que es de la sesion 2). 
                index_ni = index_2(:) == k; 
                suma = sum(index_ni);
                if suma == 0
                    contador = contador + 1; % Al tamano actual de map_index se le va sumando 1. 
                    index_map(length_map_index + contador,i) = k;
                    increase_in_index_map = length(index_map) - length_map_index;
                    selec_raw_inicial = (length(index_map) - increase_in_index_map)+1;
                end
            end
        end
    end
end
