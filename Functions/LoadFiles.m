function[file_name, path_name, data_archivo, file_id, number_id] = LoadFiles
%% Load several data


%% Moises AC 02.dic.2019
%% Start
[file_name, path_name] = uigetfile('*', 'Select coordinates file', 'MultiSelect', 'on');
data_archivo = strcat(path_name,file_name);

% If you enter only one file, this part of code allows you to continue
% changing 'char' variable to 'cell'
type_data_archivo = class(data_archivo);
type_file_name = class(file_name);
if type_data_archivo == 'char'
    data_archivo = {data_archivo};
end
if type_file_name == 'char'
    file_name = {file_name};  
end

file_id = file_name;
for i = 1:length(file_name)
file_id{i} = file_name{i}(1: end - 4);
end
number_id = 1:length(data_archivo);
end




