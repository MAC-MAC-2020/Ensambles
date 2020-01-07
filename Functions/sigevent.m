function sig_events = sigevent(Umbral,file_name,path_name)
%% Detect Significant Calcium Events
% This function estimate the significant calcium values that is above
% estimate threshold (SD), then it binarize following this criteria.
% Inputs: 
% matriz of transients 'n X m' where; n = number of neurons and m = time in frames 
% threshold: above this number of SD, the values are significant.
% Outputs:
% matriz of significant events 'n X m'.

%%  Moises AC 4.ago.2019

%% Select files interactively
% [file_name, path_name] = uigetfile('*.mat', 'Select coordinates file', 'MultiSelect', 'on');
data_archivo=strcat(path_name,file_name);

minutes = 120;

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

% Indicate file id for name files
file_id = file_name;
for i = 1:length(file_name)
file_id{i} = file_name{i}(1: end - 4);
end
%%

for k = 1:length(data_archivo)
    Datos = importdata(data_archivo{k});
    Transients = Datos.sigfn;

sig_events = zeros(size(Transients));

Transients = Transients';
Derivative_Transients = diff(Transients);
DesEst = std(Derivative_Transients);
DesEst = DesEst*Umbral;
Derivative_Transients = Derivative_Transients';

% Select values subthreshold

for i = 1:size(Transients,2)
    
    neuron = (Derivative_Transients(i,:));
    
    for j = 1:length(neuron)
        if neuron(j) <= DesEst(i)
            neuron(j) = 0;
        elseif neuron(j) > DesEst(i)
            neuron(j) = 1;
        end
        sig_events(i,j) = neuron(j);
    end
end

% Take on only the last 9 minutes (180 frames)
sig_events = sig_events(:,length(sig_events)-minutes:end);

%Datos.sig_events = sig_events;
    
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
    
    % Save in the same file
    WorkFolder = cd; cd(path_name);
    save([path_name, file_id{k}], 'bgffn','bgfn','corr_score','imax','imaxn','imaxy','Params','pixh', 'pixw','raw_score','roifn', 'roifnr','seedsfn','sigfn','sigfnr','spkfn','sig_events')
%     save(file_name{k},'Datos');  
    cd(WorkFolder);
    
end
end


