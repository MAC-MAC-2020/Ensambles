 function [all_neurons_position] = neuronsposition(cell_registered_struct)
% treshold = 5;
% sesion_refer = 1;
centroids_corr = cell_registered_struct.centroid_locations_corrected;
num_sesions = length(centroids_corr)-1;
%% Number of total neurons
   total_neurons = zeros(length(centroids_corr),1);
for l = 1:length(centroids_corr)
   total_neurons(l) = length(centroids_corr{l});
end

%% Position of all neurons

all_neurons_position = cell(num_sesions); % Preallocate memory
for i = 1:length(centroids_corr)-1
    % Extract centroids A
    centroides_A = centroids_corr{i};
    h = i+1;  
    for j = h:length(centroids_corr)
        col = j-1;
        % Extract centroids B
        centroides_B = centroids_corr{h};
        % Calculate distance
        distance = pdist2(centroides_A,centroides_B);
        
        
        %% Option 3
        tamanoF = size(distance,1);
        tamanoC = size(distance,2);
        % celulas mas cercanas para las filas
        minimo_filas1 = min(distance,[],2);
        minimo_filas2 = minimo_filas1<=5;
        minimo_filas3 =  minimo_filas1(minimo_filas2);
        indices_coordenadas = zeros(length(minimo_filas3),1);
        for k = 1:length(minimo_filas3)
            %Saldra errr si un numero minimo se repite
            indices_coordenadas(k,1) = find(distance == minimo_filas3(k));
        end
        [coor_cell_filas(:,1),coor_cell_filas(:,2)] = ind2sub([tamanoF tamanoC],indices_coordenadas);
        
        % celulas mas cercanas para las columnas
        minimo_columnas1 = min(distance);
        minimo_columnas2 = minimo_columnas1<=5;
        minimo_columnas3 =  minimo_columnas1(minimo_columnas2);
        indices_coordenadas_columnas = zeros(length(minimo_columnas3),1);
        for k = 1:length(minimo_columnas3)
            indices_coordenadas_columnas(k,1) = find(distance == minimo_columnas3(k));
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
        for k = 1:length(position_same_neurons)
            position_same_neurons(k,:) = coor_cell_filas(same_neurons(k),1:2);
        end
       
       
       all_neurons_position{i,col} =  position_same_neurons;
       h = h+1;  
       clear 'coor_cell_filas' 'coor_cell_columnas'
    end
end
end
% %%
% 
% 
% 
% shared_neurons(i) = length(position_same_neurons); % Cuenta cuantas celulas se compartieron para esta comparacion en esta vuelta
% 
% % Extraccion de centroides de las mismas neuronas SESION DE REFERENCIA
%  cent_sesion_refer = centroids_corr{sesion_refer};
%  centroids_same_neurons_sesion_refer = NaN(length(cent_sesion_refer),2);
%  centroids_same_neurons_sesion_refer(position_same_neurons(:,sesion_refer),:) = cent_sesion_refer(position_same_neurons(:,sesion_refer),:);
% 
% % Extraccion de centroides de las mismas neuronas SESION COMPLEMENTARIA
% sesion_comparar = i;
% cent_sesion_comparar = centroids_corr{sesion_comparar};
% centroids_same_neurons_sesion_comparar = NaN(length(cent_sesion_comparar),2);
% centroids_same_neurons_sesion_comparar(position_same_neurons(:,2),:) = cent_sesion_comparar(position_same_neurons(:,2),:);
% 
%  regneuron = centroids_same_neurons_sesion_refer;
%  all_reg_neurons{1,1} = 'Posicion de celulas';
%  all_reg_neurons{1,2} = 'Centroides de las celulas "referencia"';
%  all_reg_neurons{1,3} = 'Centroides de las celulas "comparadas"';
%  
%  all_reg_neurons{i,1} = position_same_neurons;
%  all_reg_neurons{i,2} = centroids_same_neurons_sesion_refer;
%  all_reg_neurons{i,3} = centroids_same_neurons_sesion_comparar;
%  
% %  register_neurons.all_reg_neurons = all_reg_neurons;
% %  register_neurons.total_neurons = total_neurons;
% %  register_neurons.shared_neurons = shared_neurons;
%  
%  flag = flag + 1;
%  
%  clear 'coor_cell'
%  
% 
% 
%  shared_neurons(shared_neurons == 0) = [];
%  register_neurons.all_reg_neurons = all_reg_neurons;
%  register_neurons.total_neurons = total_neurons;
%  register_neurons.shared_neurons = shared_neurons;
%  file_name = file_name{1}(1:end-25);
%  
%  save([path_name,  'register_neurons_sesion_' file_name], 'register_neurons')
% end