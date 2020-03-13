% function RGB_maps(active_neuron_centroid_ensamble_Luz_Tono,footprints_ensamble_LUZ_TONO,active_neuron_centroid_compartidas,ensayo_L,ensayo_T)
ensayo_L = 1;
ensayo_T = 7;
%% Crear una imax de plantilla para extraer nuevos footprints con los centroides corregidos
size_fp = size(footprints_ensamble_LUZ_TONO{1});
imax_template = ones(size_fp(3),size_fp(2))*0.5;
%% Luz
% Sacar centroides para ensamble luz
active_neuron_centroid_ensamble_Luz = active_neuron_centroid_ensamble_Luz_Tono{ensayo_L};
active_neuron_centroid_ensamble_Luz_logical = active_neuron_centroid_ensamble_Luz(:,1) > 0;
% Sacar centroides para compartidas luz
active_neuron_centroid_compartidas_Luz = active_neuron_centroid_compartidas{ensayo_L};
active_neuron_centroid_compartidas_Luz_logical = active_neuron_centroid_compartidas_Luz(:,1) > 0;
% Sacar centroides para luz todas
active_neuron_centroid_Luz_todas = active_neuron_centroid_Luz_Tono_todas{ensayo_L};
% Quitar de todos los centroides de aquellas celulas que estan en el ensamble
neurons_actives_ensamble_Luz_logical = active_neuron_centroid_ensamble_Luz > 0;
active_neuron_centroid_Luz_todas(neurons_actives_ensamble_Luz_logical) = NaN;
%% Tono
% Sacar centroides para ensamble Tono
active_neuron_centroid_ensamble_Tono = active_neuron_centroid_ensamble_Luz_Tono{ensayo_T};
active_neuron_centroid_ensamble_Tono_logical = active_neuron_centroid_ensamble_Tono(:,1) > 0;
% Sacar centroides para compartidas Tono
active_neuron_centroid_compartidas_Tono = active_neuron_centroid_compartidas{ensayo_T};
active_neuron_centroid_compartidas_Tono_logical = active_neuron_centroid_compartidas_Tono(:,1) > 0;
% Sacar centroides para Tono todas
active_neuron_centroid_Tono_todas = active_neuron_centroid_Luz_Tono_todas{ensayo_T};
% Quitar de todos los centroides de aquellas celulas que estan en el ensamble
neurons_actives_ensamble_Tono_logical = active_neuron_centroid_ensamble_Tono > 0;
active_neuron_centroid_Tono_todas(neurons_actives_ensamble_Tono_logical) = NaN;
%% Sacar centroides de neuronas de la interseccion
% Sacar posicion de las neuronas de la interseccion 
position_ni = register_neurons_post.all_neurons_position{ensayo_L,ensayo_T-1};
% Sacar centroides 
interseccion_neuronas_ensamble_Luz = active_neuron_centroid_ensamble_Luz(position_ni(:,1),:); 
interseccion_neuronas_ensamble_Tono = active_neuron_centroid_ensamble_Tono(position_ni(:,2),:);
%% Razon de la recta en dos
% Sacar nuevos puntos
new_points = zeros(length(position_ni),2);
for i = 1:size(position_ni,1)
    
    pointA = active_neuron_centroid_ensamble_Luz(position_ni(i,1),:);
    pointB = active_neuron_centroid_ensamble_Tono(position_ni(i,2),:);
    
    X_new = (pointA(1,1)+pointB(1,1))/2; 
    Y_new = (pointA(1,2)+pointB(1,2))/2; 
    new_points(i,:) = [X_new,Y_new];
    
end
% Remplazar nuevos puntos
active_neuron_centroid_ensamble_Luz_remplazados =  active_neuron_centroid_ensamble_Luz;
active_neuron_centroid_ensamble_Luz_remplazados(position_ni(:,1),:) =  new_points;
active_neuron_centroid_ensamble_Tono_remplazados = active_neuron_centroid_ensamble_Tono;
active_neuron_centroid_ensamble_Tono_remplazados(position_ni(:,2),:) =  new_points;
% 
active_neuron_centroid_Luz_todas(position_ni(:,1),:) =  new_points;
%% Extraer nuevos footprints de neuronas de la interseccion
centroids{1} = fliplr(active_neuron_centroid_Luz_todas); % Uso la funcion fliplr para girar los coordenados porque estos centroides vienen de registerneuron, en donde se giran.
centroids{2} = fliplr(active_neuron_centroid_Tono_todas);
centroids{3} = fliplr(active_neuron_centroid_ensamble_Luz_remplazados);
centroids{4} = fliplr(active_neuron_centroid_ensamble_Tono_remplazados);
footprints = cell(length(centroids),1);
size_neuron = 5;
for i = 1:length(centroids)
centroids_ni = centroids{i};
footprints_ni = footprint(imax,centroids_ni,size_neuron);
footprints{i} = footprints_ni;
end

% Sacar footprints
fotprint_Luz_todas = footprints{1};
fotprint_Tono_todas = footprints{2};
fotprint_Luz_ensamble_remplazadas = footprints{3};
fotprint_Tono_ensamble_remplazadas = footprints{4};
% % Permutar footprints
fotprint_Luz_todas = permute(fotprint_Luz_todas,[3,2,1]);
fotprint_Tono_todas =  permute(fotprint_Tono_todas,[3,2,1]);
fotprint_Luz_ensamble_remplazadas  = permute (fotprint_Luz_ensamble_remplazadas ,[3,2,1]);
fotprint_Tono_ensamble_remplazadas = permute (fotprint_Tono_ensamble_remplazadas,[3,2,1]);

%% Juntar matrices para formar imagen R,G,B.
% R = todas las celulas en luz y tono
spatial_footprint_Luz_Tono_todas = cat(3,fotprint_Luz_todas,fotprint_Tono_todas);
R = sum(spatial_footprint_Luz_Tono_todas,3);
R(R>0)= 1;
% G = ensamble presente en luz
G = sum(fotprint_Luz_ensamble_remplazadas,3);
G(G>0) = 1;
% B = ensamble presente en tono
B = sum(fotprint_Tono_ensamble_remplazadas,3);
B(B>0) = 1;
% Por tanto compartidas = suma de G y B.
imagen_RGB = cat(3,R,G,B); 
imshow(imagen_RGB)
% hold on
% plot(active_neuron_centroid_ensamble_Luz(:,2),active_neuron_centroid_ensamble_Luz(:,1),'o g')%,'MarkerEdgeColor','b', 'MarkerFaceColor','r');
% plot(active_neuron_centroid_ensamble_Tono(:,2),active_neuron_centroid_ensamble_Tono(:,1),'o b')%,'MarkerEdgeColor','b', 'MarkerFaceColor','r');
% plot(new_points(:,2),new_points(:,1),'. w','MarkerSize',12)
% % axis square
% hold off
% 

im= image(imagen_RGB,'CDataMapping','scaled');
% im.AlphaData = 0.5;
