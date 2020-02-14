function distances = distcentroid(centroids)
%% Distance calculation 13.mar.20

% input
% option 1 struct: cell_registered_struct: Alingned centroids of Cell-Register
% Option 2 double: only the pairs centroids (x,y) 

% otput
% In cell variable MxM: Ditances on one cell from all others in an trail and between trails

c = class(centroids);
if c == 'struct'
     centroid = centroids.centroid_locations_corrected;

elseif c == 'double'
     centroid{1} = centroids;
end

distances = cell(length(centroid));

for i = 1:length(centroid)
    centroids_ni = centroid{i};
    
    for j = 1:length(centroid)
        
    centroids_nj = centroid{j};
    
    distances{j,i} = pdist2(centroids_ni,centroids_nj);
        
    end
    
end


% ESTE APARTADO SOLO SACA LOS HISTOGRAMAS 

% distances_corr_A = distances{1,1};
% distances_corr_B = distances{2,2};
% distances_corr_AB = distances{2,1};
% 
% load('cincuentamsCamA_data_processed_prueba')
% centroidsA = Extract_Centroids(pixh,pixw,seedsfn);
% load('cincuentamsCamB_data_processed_prueba')
% centroidsB = Extract_Centroids(pixh,pixw,seedsfn);
% 
% distances_A = pdist2(centroidsA,centroidsA);
% distances_B = pdist2(centroidsA,centroidsB);
% distances_AB = pdist2(centroidsA,centroidsB);
% 
% figure(1)
% % plots AB
% subplot(2,3,1)
% hold on
% plot(centroidsA(:,1),centroidsA(:,2),'o R');
% plot(centroidsB(:,1),centroidsB(:,2),'o G');
% title('centroids AB')
% hold off
% 
% subplot(2,3,2)
% histogram(distances_A)
% title('distancia A')
% 
% subplot(2,3,3)
% distances_AB = distances_AB';
% distances_AB_min = min(distances_AB);
% dist_min5_AB = distances_AB_min; 
% k = find(dist_min5_AB<10);
% dist_min5_AB = dist_min5_AB(k);
% histogram(distances_AB_min)
% title('distancia AB')
% 
% %plots corr AB
% subplot(2,3,4)
% hold on
% centroids_corr_A = centroid_locations_corrected{1};
% centroids_corr_B = centroid_locations_corrected{2};
% plot(centroids_corr_A(:,2),centroids_corr_A(:,1),'o R');
% plot(centroids_corr_B(:,2),centroids_corr_B(:,1),'o B');
% title('centroids corr AB')
% hold off
% 
% subplot(2,3,5)
% histogram(distances_corr_A)
% title('distancia corr A')
% 
% subplot(2,3,6)
% distances_corr_AB = distances_corr_AB';
% distances_corr_AB_min = min(distances_corr_AB);
% 
% dist_min5_AB = distances_corr_AB_min; 
% k = find(dist_min5_AB<10);
% dist_min5_AB = dist_min5_AB(k);
% 
% histogram(dist_min5_AB)
% histogram(distances_corr_AB_min)
% title('distancia corr AB')