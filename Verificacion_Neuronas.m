%% Verificacion de neuronas
% Este script permite mostrar las neuronas activas durante todo el ensayo 
% con el valor maximo del pixel y graficar los centroides en cada neurona detectada.

% input
% 1.- Video Original
% 2.- Archivo con los centroides ("data_proceced" de min1pipe) 

% output
% 1.- imagen con la huella de las nuronas con valor minima y maxima de cada pixel

%% Moises Altamira 05.dic.2019
% Act. 07.ene.2020

    %% Load
    [video_name, video_path, video_data, video_id, video_idx] = LoadFiles; % Choose video
    [file_name, path_name, data_archivo, file_id, number_id] = LoadFiles;  % Choose file with centroids (min1pipe data_processed)
    
    %%
    Vid = VideoReader(video_data{1});
    name = Vid.Name(1:end-4);
    framerate = Vid.FrameRate;
    frames = Vid.Duration*framerate;
    width = Vid.Width;
    heigth = Vid.Height;
    %% Frame extract
    vid2mat = zeros(heigth,width,frames);
    for i = 1:frames
        im = read(Vid,i);
        im = double(im);
        im = sum(im,3);
        vid2mat(:,:,i) = im;
    end
    %% Extract values for plot centroids in Max Projection
    Datos = importdata(data_archivo{1});
    pixh = Datos.pixh;
    pixw = Datos.pixw;
    seedsfn = Datos.seedsfn;
    imax = Datos.imax;
    [x, y] = ind2sub([pixh, pixw], seedsfn);
    %% Images of Reference
    imrefer_max = max(vid2mat,[],3);
    imrefer_min = min(vid2mat,[],3);
    colormap('gray')
    subplot(1,2,1)
    imagesc(imrefer_min)
    title('Min Projection')
    axis square
    subplot(1,2,2)
    imagesc(imrefer_max)
    hold on
    plot(y,x,'o r')
    axis square
    title('Max Projection')
    %%
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    