function neuronas_activas_estimulo = neuactiestimulo(stimulus,sigfn,centroids)
%% Neuronas significativas en estimulo

% treshold of DS
threshold = 2.5;



tiempo_estimulo = stimulus.stimulus;
% Derivada de la senial 
deri_sigfn = diff(sigfn,[],2);
% Desviacion estandar
std_deri = (std(deri_sigfn,[],2))*threshold;
% Eliminar valores inferiores a std en derivada
eventos = deri_sigfn>=std_deri;
% Seleccionar eventos en tiempo de estimulacion
sigfn_estimulo = eventos(:,tiempo_estimulo(1):tiempo_estimulo(2));
% Contar los numeros de eventos por celula
num_eventos_estimulo = sum(sigfn_estimulo,2);
% Estadisticos del numero de eventos (QUEDA PENDIENTE, POR LO PRONTO, UNA
% NEURONA SE CONSIDERA ACTIVA SI PRESENTA POR LO MENOS tres EVENTOS)
% prom_eventos = round(mean(num_eventos));
% std_eventos = round(std(num_eventos));
% Si la neurona tuvo actividad menos una desviacion estandar del promedio
% no se cuenta como activa
neuronas_activas_estimulo = num_eventos_estimulo >= 1; %(prom_eventos-std_eventos); 
% Centroides de las neuronas activas
neuronas_activas_estimulo = (centroids.*neuronas_activas_estimulo);
neuronas_activas_estimulo(neuronas_activas_estimulo == 0) = NaN;


end
