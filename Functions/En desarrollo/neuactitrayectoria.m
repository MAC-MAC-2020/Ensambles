function neuronas_activas_trayectoria = neuactitrayectoria(stimulus,sigfn,centroids)
%% Neuronas significativas en estimulo
threshold = 2.5; % Desviciones estandar

tiempo_estimulo = stimulus.stimulus;
% Derivada de la senial 
deri_sigfn_trayectoria = diff(sigfn,[],2);
% Desviacion estandar
std_deri = (std(deri_sigfn_trayectoria,[],2))*threshold;
% Eliminar valores inferiores a std en derivada
eventos = deri_sigfn_trayectoria>=std_deri;
% Seleccionar solo enventos durante el recorrido
sigfn_trayectoria = eventos(:,tiempo_estimulo(2):length(sigfn)-1);
% Contar los numeros de eventos por celula
num_eventos = sum(sigfn_trayectoria,2);
% Estadisticos del numero de eventos (QUEDA PENDIENTE, POR LO PRONTO, UNA
% NEURONA SE CONSIDERA ACTIVA SI PRESENTA POR LO MENOS UN EVENTO)
% prom_eventos = round(mean(num_eventos));
% std_eventos = round(std(num_eventos));
% Si la neurona tuvo actividad menos una desviacion estandar del promedio
% no se cuenta como activa
neuronas_activas_trayectoria = num_eventos >= 1; %(prom_eventos-std_eventos); 
% Centroides de las neuronas activas
neuronas_activas_trayectoria = (centroids.*neuronas_activas_trayectoria);
neuronas_activas_trayectoria(neuronas_activas_trayectoria == 0) = NaN;


end
