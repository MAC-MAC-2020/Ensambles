function m = mapsim(A)
% Mapa de similitid
% A = Matriz de m x n donde m = neuronas y n = frames

%% Moises AC 07.ago.2019

%% Start
m = zeros(length(A)); % Matriz de similitud dada por el angulo
for i = 1:length(m);
    u = A(:,i); 
    for j = 1:length(m);  
    v = A(:,j);
    ProductoPunto = dot(u,v); % Calcula el producto punto de 'u' y 'v'
    longU = norm(u); % longitud del vector 
    longV = norm(v); % longitud del vector 
    costeta = ProductoPunto/(longU*longV); %Calcula el Coseno de teta
    teta = acos(costeta); % Angulo en radianes
    m(i,j) = teta;
    end
end
m = real(m);
m = flip(m);
m = (m.*1)/1.5708; % Toma el valor mayor igual a uno.
m = (1-m); % Invierte los valores maximos a minimos y visceversa.

figure(1)
clims = [0 1]; % Crea los limites de la escala de 0 a 1
imagesc(m,clims);
colormap(hot)
colorbar
axis square
title('MAPA DE SIMILITUD','FontSize',15,'FontWeight','bold')
xlabel('Vector i (t)','FontSize',15,'FontWeight','bold')
ylabel('Vector i (t)','FontSize',15,'FontWeight','bold')
saveas(gcf,'Mapa_Similitud.bmp')

end






