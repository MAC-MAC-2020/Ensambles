function [Num_Neuronas,Promedio_Numero_Neuronas] = Numero_de_Neuronas(Ensayos,Sesiones,file_name,path_name)

%% Numero de Neuronas
%Del archivo "...data_processed" extrae el numero de neuronas activas en ese ensayo.

%Inputs:

%EL NUMERO DE ENSAYOS TIENE QUE SER EQUIVALENTE EN TOTAS LAS SESIONES. EN
%CASO DE QUE NO SE CUMPLA ESTA CONDICION USAR "data_processed-relleno" PARA
%INCLUIR UN NaN EN LA MATRIZ.

% 1.- Numero de ensayos
% 2.- Numero de sesiones (actualmente es posible hasta la sesion 51)

%Outputs
% 1.- "Num_Neuronas" -> numero de neuronas
% 2.- "Promedio_Numero_Neuronas" -> Promedio del Numero de Neuronas. 

%% Moises AC 07.oct.2019

%% Select files interactively
% [file_name, path_name] = uigetfile('*.mat', 'Select coordinates file', 'MultiSelect', 'on');
data_archivo=strcat(path_name,file_name);

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

%% Definir Parametros
Total_Ensayos = Ensayos;
Total_Sesiones = Sesiones; % Numero de sesione que se esten analizando 
Num_Neuronas = zeros(length(data_archivo),Total_Sesiones);

%% Inicio

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
    Num_Neuronas(i,Sesion_Actual) = size(Datos.sigfn,1);
    
    if Num_Neuronas(i,Sesion_Actual) == 1
       Num_Neuronas(i,Sesion_Actual) = NaN ;
    end

end

Num_Neuronas = nonzeros(Num_Neuronas);
Num_Neuronas = reshape(Num_Neuronas,Total_Ensayos,Total_Sesiones);

Promedio_Numero_Neuronas = nanmean(Num_Neuronas);
%plot(Promedio_Numero_Neuronas)


%% Save
WorkFolder = cd; cd(path_name); 
save('Numero_Neuronas','Num_Neuronas','Promedio_Numero_Neuronas'); %Guarda solo variable de interes
cd(WorkFolder);

end