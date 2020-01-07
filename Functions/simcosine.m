function [simcosine,Average_simcosine,All_Similitudes] = simcosine(Ensayos,Sesiones,file_name,path_name)
%% Simimlitude Cosine
% This function calculate the Simimlitude Cosine between all cells by rows

% Inputs:
% Matrix 'm x n'; where m = number of cells, n = time in frames.

% Outputs
% Matrix with silitude values, from 0 to 1. 
% where 0 = low similarity and 1 = high similarity 
% Average of all values. 

%% Moises AC 07.ago.2019

%% Start 
data_archivo = strcat(path_name,file_name);
% If you enter only one file, this part of code allows you to continue
% changing 'char' variable to 'cell

type_data_archivo = class(data_archivo);
type_file_name = class(file_name);
if type_data_archivo == 'char'
    data_archivo = {data_archivo};
end
if type_file_name == 'char'
    file_name = {file_name};  
end

% Indicate file id for name files.
file_id = file_name;
for i = 1:length(file_name)
file_id{i} = file_name{i}(1: end - 4);
end

%% Definir Parametros
Total_Ensayos = Ensayos;
Total_Sesiones = Sesiones; % Numero de sesione que se esten analizando
All_Similitudes = zeros(length(data_archivo),Total_Sesiones);
%% Compute Similitude
for k = 1:length(data_archivo)
    Datos = importdata(data_archivo{k});

Transients = Datos.sig_events;
Transients = Transients';

simcosine = zeros(size(Transients,2));% Matriz de similitud dada por el angulo


for i = 1:length(simcosine)
    u = Transients(:,i); 
    for j = 1:length(simcosine)  
    v = Transients(:,j);
%     ProductoPunto = dot(u,v); % Calcula el producto punto de 'u' y 'v'
%     longU = norm(u); % longitud del vector 
%     longV = norm(v); % longitud del vector 
%     costeta = ProductoPunto/(longU*longV); %Calcula el Coseno de teta
%     teta = acos(costeta); % Angulo en radianes
  corre = corr(u,v);
  simcosine(i,j) = corre;
%     simcosine(i,j) = teta;
    end
end
%     %Preparing output matriz 
%     simcosine = real(simcosine);
%     %similitude = flip(similitude);
%     maxindex = max(max(simcosine)); 
%     simcosine = simcosine./maxindex; % Normalize between 0 to 1
%     simcosine = (1-simcosine); 
    Average_simcosine = nanmean(nanmean(simcosine));
    
    % Create struct variable simcosine, with simcosine and Average_simcosine
    Datos.simcosine.simcosine = simcosine;
    Datos.simcosine.Average_simcosine = Average_simcosine;
    
    %% Save significan events in the same file 
    
    % Stract variables from Datos
    bgffn = Datos.bgffn;  
    bgfn = Datos.bgfn; 
    corr_score  = Datos.corr_score; 
    imax = Datos.imax;
    imaxn = Datos.imaxn; 
    imaxy = Datos.imaxy; 
    Params = Datos.Params; 
    pixh = Datos.pixh; 
    pixw = Datos.pixw; 
    raw_score = Datos.raw_score; 
    roifn = Datos.roifn; 
    roifnr = Datos.roifnr; 
    seedsfn = Datos.seedsfn; 
    sigfn = Datos.sigfn; 
    sigfnr = Datos.sigfnr; 
    spkfn = Datos.spkfn; 
    sig_events = Datos.sig_events;
    simcosine = Datos.simcosine.simcosine; 
    Average_simcosine = Datos.simcosine.Average_simcosine;
    
    % Save simcosine in the same file 
    WorkFolder = cd; cd(path_name); 
    save([path_name, file_id{k}], 'bgffn','bgfn','corr_score','imax','imaxn','imaxy','Params','pixh', 'pixw','raw_score','roifn', 'roifnr','seedsfn','sigfn','sigfnr','spkfn','sig_events','simcosine','Average_simcosine')
    % save(file_name{k},'Datos');  
    cd(WorkFolder);

end
%% Compute Matriz of All Similitudes


for i = 1:length(data_archivo)
    
    id_sesion = file_name{i};
    id_sesion = id_sesion(1:8);
    
    if id_sesion == 'unomsCam'
        Sesion = 1;
    elseif id_sesion == 'dosmsCam'
        Sesion = 2;
    elseif id_sesion == 'tresmsCa'
        Sesion = 3;
    elseif id_sesion == 'cuatroms'
        Sesion = 4;
    elseif id_sesion == 'cincomsC'
        Sesion = 5;
    elseif id_sesion == 'seismsCa'
        Sesion = 6;
    elseif id_sesion == 'sietemsC'
        Sesion = 7;
    elseif id_sesion == 'ochomsCa'
        Sesion = 8;
    elseif id_sesion == 'nuevemsC'
        Sesion = 9;
    elseif id_sesion == 'diezmsCa'
        Sesion = 10;
    elseif id_sesion == 'oncemsCa'
        Sesion = 11;
    elseif id_sesion == 'docemsCa'
        Sesion = 12;
    elseif id_sesion == 'trecemsC'
        Sesion = 13;
    elseif id_sesion == 'catorcem'
        Sesion = 14;
    elseif id_sesion == 'quincems'
        Sesion = 15;
    elseif id_sesion == 'diecisei'
        Sesion = 16;
    elseif id_sesion == 'diecisie'
        Sesion = 17;
    elseif id_sesion == 'diecioch'
        Sesion = 18;
    elseif id_sesion == 'diecinue'
        Sesion = 19;
    elseif id_sesion == 'veintems'
        Sesion = 20;
    elseif id_sesion == 'veintiun'
        Sesion = 21;
    elseif id_sesion == 'veintido'
        Sesion = 22;
    elseif id_sesion == 'veintitr'
        Sesion = 23;
    elseif id_sesion == 'veinticu'
        Sesion = 24;
    elseif id_sesion == 'veintici'
        Sesion = 25;
    elseif id_sesion == 'veintise'
        Sesion = 26;
    elseif id_sesion == 'veintisi'
        Sesion = 27;
    elseif id_sesion == 'veintioc'
        Sesion = 28;
    elseif id_sesion == 'veintinu'
        Sesion = 29;
    end
    
    id_sesion = file_name{i};
    id_sesion = id_sesion(1:12); % Here, id_session take values up to 12.
    
if  id_sesion == 'treintamsCam'
        Sesion = 30;
    elseif id_sesion == 'treintayunom'
        Sesion = 31;
    elseif id_sesion == 'treintaydosm'
        Sesion = 32;
    elseif id_sesion == 'treintaytres'
        Sesion = 33;
    elseif id_sesion == 'treintaycuat'
        Sesion = 34;
    elseif id_sesion == 'treintaycinc'
        Sesion = 35;
    elseif id_sesion == 'treintayseis'
        Sesion = 36;
    elseif id_sesion == 'treintaysiet'
        Sesion = 37;
    elseif id_sesion == 'treintayocho'
        Sesion = 38;
    elseif id_sesion == 'treintaynuev'
        Sesion = 39;
    elseif id_sesion == 'cuarentamsCa'
        Sesion = 40;
    elseif id_sesion == 'cuarentayuno'
        Sesion = 41;
    elseif id_sesion == 'cuarentaydos'
        Sesion = 42;
    elseif id_sesion == 'cuarentaytre'
        Sesion = 43;
    elseif id_sesion == 'cuarentaycua'
        Sesion = 44;
    elseif id_sesion == 'cuarentaycin'
        Sesion = 45;
    elseif id_sesion == 'cuarentaysei'
        Sesion = 46;
    elseif id_sesion == 'cuarentaysie'
        Sesion = 47;
    elseif id_sesion == 'cuarentayoch'
        Sesion = 48;
    elseif id_sesion == 'cuarentaynue'
        Sesion = 49;
    elseif id_sesion == 'cincuentamsC'
        Sesion = 50;
    elseif id_sesion == 'cincuentayun'
        Sesion = 51;
    elseif id_sesion == 'cincuentaydo'
        Sesion = 52;
end
    
Sesion_Actual = Sesion;


 
    Datos = importdata(data_archivo{i});
    All_Similitudes(i,Sesion_Actual) = (Datos.Average_simcosine);
    
    if All_Similitudes(i,Sesion_Actual) == 0 
       All_Similitudes(i,Sesion_Actual) = NaN ;
    end

end

All_Similitudes = nonzeros(All_Similitudes);
All_Similitudes = reshape(All_Similitudes,Total_Ensayos,Total_Sesiones);

% Promedio_Numero_Neuronas = nanmean(All_Similitudes);
%plot(Promedio_Numero_Neuronas)


  % Save in the same file
WorkFolder = cd; cd(path_name);
save('ALL_Similitudes','All_Similitudes'); %Guarda solo variable de interes
cd(WorkFolder);


end

