clear
clc
%% Proportion  of same cells across session 
load('cellRegistered_20200211_131212')

% Obtaining distance and centroid variables 
distances = distcentroid(cell_registered_struct);
centroids_corr = cell_registered_struct.centroid_locations_corrected;
treshold = .5;
    
distance = distances{7};

% Option 1

valmin1 = (distance<=treshold & distance>0);
valmin1 = (valmin1.*distance);

[coor_cell1(:,1),coor_cell1(:,2),coor_cell1(:,3)] = find(valmin1);
[raw,col,dist] = find(valmin1);

% celulas mas cercanas para las filas
new_coor_raw = zeros(length(dist),3);
for i = 1:length(dist)
    raw_ni = find(raw == raw(i));
    val_min = min(dist(raw_ni));
    posi_val_min = find(dist == val_min); % Solo sera valido si el valor minimo no se repite
    new_coor_raw(i,:) = coor_cell1(posi_val_min,:);
end
new_coor_raw = unique(new_coor_raw,'rows');


% celulas mas cercanas para las columnas
new_coor_col = zeros(length(dist),3);
for i = 1:length(dist)
    col_ni = find(col == col(i));
    val_min = min(dist(col_ni));
    posi_val_min = find(dist == val_min); % Solo sera valido si el valor minimo no se repite
    new_coor_col(i,:) = coor_cell1(posi_val_min,:);
end
new_coor_col = unique(new_coor_col,'rows');

fila = new_coor_raw(:,1);
columna = new_coor_col(:,1);  % IMPORTA SI SE PREGUNTA POR RENGLON-COLUMNA o COLUMNA-RENGLON????

columna_unique = unique(columna);

position_same_neurons = zeros(length(columna_unique),1);
for i = 1:length(position_same_neurons)
    position_same_neurons(i) = find(fila == columna_unique(i)); 
end

same_neurons = zeros(length(position_same_neurons),2);

for i = 1:length(same_neurons)
   
    same_neurons(i,:) = new_coor_raw(position_same_neurons(i),1:2);
end

centA = centroids_corr{1};
centB = centroids_corr{2};

centA_same = zeros(length(same_neurons),2);
centB_same = zeros(length(same_neurons),2);

for i = 1:length(same_neurons)
    centA_same(i,:) = centA(same_neurons(i,2),:);
end
for i = 1:length(same_neurons)
    centB_same(i,:) = centB(same_neurons(i,1),:);
end


hold on
plot(centA(:,1),centA(:,2),'. r','MarkerSize',25)
plot(centB(:,1),centB(:,2),'. b','MarkerSize',25)
plot(centA_same(:,1),centA_same(:,2),'. G','MarkerSize',30)
plot(centB_same(:,1),centB_same(:,2),'. G','MarkerSize',30)

axis square


% %% Option 2
% 
% valmin2 = (min(distance,[],2));
% %valmin3 = (min(distance,[],1));
% 
% valmin2 = valmin2(valmin2<=5);
% %valmin3 = valmin3(valmin3<=5);
% 
% coor_cell2_raw = zeros(size(valmin2,1),2);
% for j = 1:length(valmin2) 
%     [coor_cell2_raw(j,1),coor_cell2_raw(j,2)] =  find(distance==valmin2(j));
% end
% 
% % coor_cell2_col = zeros(size(valmin3,1),2);
% % for j = 1:length(valmin3) 
% %     [coor_cell2_col(j,1),coor_cell2_col(j,2)] =  find(distance==valmin3(j));
% % end

