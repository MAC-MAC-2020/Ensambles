%%
clear

load 'cellRegistered_20200219_002136'
[all_neurons_position] = neuronsposition(cell_registered_struct);

centroids_corr = cell_registered_struct.centroid_locations_corrected;

%% Number of total neurons
   total_neurons = zeros(length(centroids_corr),1);
for i = 1:length(centroids_corr)
   total_neurons(i) = length(centroids_corr{i});
end

sesion1(:,1) = 1:total_neurons(1);
map_index = zeros(total_neurons(1),length(centroids_corr)); 
map_index(:,1) = sesion1;


for i = 1:length(all_neurons_position)
    for j = 1:length(all_neurons_position)
        col = j+1;
        is_empty = isempty(all_neurons_position{i,j});
        if is_empty == 0
            index_1 = all_neurons_position{i,j};
            for k = 1:length(index_1)
                map_index_raw = find(map_index(:,i) == index_1(k));
                map_index(map_index_raw,col) = index_1(k,2);
            end
        elseif is_empty == 1
            index_2 = map_index(:,i);
            length_map_index = length(map_index);
            contador = 0;
            for k = 1:total_neurons(i)
                index_ni = index_2(:) == k;
                suma = sum(index_ni);
                if suma == 0
                    contador = contador + 1;
                    map_index(length_map_index + contador,i) = k;
                end
            end
        end
    end
end


return

ind = [0;0;0;44;35;78;10;0;91;105;90;0;128;0;0;0;149;0;0;0];

for k = 1:total_neurons(2)
    
    ind_ni = ind(:) == k
    s = sum(ind_ni)
    if s == 0
    ind(161,2) = 4
        
    end
end

u = [3 2 1 6 5 4 9 8 7 10]';
v = [2 4 3 5 6]';

for i = 1:length(v)
w(i) = find(u == v(i));
end



A = [2 3 4;
     3 4 5
     1 5 6
     5 8 2
     4 2 7
     7 5 4
     6 3 5]

B = sort(A(:,1))
