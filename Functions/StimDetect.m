function [Stimulus] = StimDetect(data_info,Sesion)
% This function return stimulation time found by turn-on time of light led
% Also, this function use 'footprint' function
% For analysis of multiple videos, you sure that they don't presented movement
% Input:
% data_info -> [path file name]
% Sesion    -> Session name
% In Command Window: Left/Right centroids in format [X,Y]. Important, first enter left centroid and then right.
% Output:
% The most important result is the first and last stimulus frame.

%% Moise AC 05.dic.2019

%% Prepare data information
files = data_info.data_archivo;
path_name = data_info.path_name;


flag = 1;
for ii = 1:length(files) % Run several files
    %% Load/Stract video info
    Vid = VideoReader(files{ii});
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
    %% Images of Reference
    imrefer_max = max(vid2mat,[],3);
    imrefer_min = min(vid2mat,[],3);
    colormap('gray')
    subplot(1,2,1)
    imagesc(imrefer_min)
    title('Min Projection')
    subplot(1,2,2)
    imagesc(imrefer_max)
    title('Max Projection')
    
    if flag == 1 % The values only one time enterd
        [centroid_input_left] = '"Enter [X,Y] value of Left:  " -->';
        centroid_left = input(centroid_input_left);
        centroids(1,1:2) = centroid_left;
        
        [centroid_input_right] = '"Enter [X,Y] value of Rigth: " -->';
        centroid_left = input(centroid_input_right);
        centroids(2,1:2) = centroid_left;
        
        radius_inpixel_input = '"Enter radius value in pixels" -->';
        radius_inpixel = input(radius_inpixel_input);
    end
    flag = -1;
    %% Cropp regions of interest using 'footprint'
    vidcropped_izq = zeros(heigth,width,frames);
    vidcropped_der = zeros(heigth,width,frames);
    for j = 1:frames
        im_processing  = vid2mat(:,:,j);
        vid_processing = footprint(im_processing,centroids,radius_inpixel);
        vid_processing = permute(vid_processing,[3,2,1]);
        vid_processing_izq = vid_processing(:,:,1);
        vid_processing_der = vid_processing(:,:,2);
        
        vidcropped_izq(:,:,j) = vid_processing_izq;
        vidcropped_der(:,:,j) = vid_processing_der;
    end
    %% Normalize Roi's
    vid_cropped_norm_izq = normalize(vidcropped_izq);
    vid_cropped_norm_der = normalize(vidcropped_der);
    %% Create vector with mean value of the matrix.
    stimulus_raw_izq = zeros(1,frames);
    stimulus_raw_der = zeros(1,frames);
    for k = 1:frames
        mean_vid_izq = mean(nonzeros(vid_cropped_norm_izq(:,:,k)));
        mean_vid_der = mean(nonzeros(vid_cropped_norm_der(:,:,k)));
        stimulus_raw_izq(k) = mean_vid_izq;
        stimulus_raw_der(k) = mean_vid_der;
    end
    %% Binarize vector with treshold of 0.93 (In the stimulus time, mean is close to 1)
    stimulus_bin_der = 1:frames;
    stimulus_bin_izq = 1:frames;
    for i = 1:frames
        if stimulus_raw_izq(i) > 0.93 % If you consider, modify treshold
            stimulus_bin_izq(i) = 1;
        else
            stimulus_bin_izq(i) = 0;
        end
        
        if stimulus_raw_der(i) > 0.93 % If you consider, modify treshold
            stimulus_bin_der(i) = 1;
        else
            stimulus_bin_der(i) = 0;
        end
    end
    %% Detect if the stimulus is left or right
    stim_detect_izq = sum(stimulus_bin_izq);
    stim_detect_der = sum(stimulus_bin_der);
    
    if stim_detect_izq ~= 0 && stim_detect_der == 0
        all_stimulus = find(stimulus_bin_izq);
        start_stim = min(all_stimulus);
        end_stim = max(all_stimulus);
        stimulus = [start_stim end_stim];
        centroids_save = centroids(1,1:2);
        Stim_Provide = 'Tone';
    elseif stim_detect_izq == 0 && stim_detect_der ~= 0
        all_stimulus = find(stimulus_bin_der);
        start_stim = min(all_stimulus);
        end_stim = max(all_stimulus);
        stimulus = [start_stim end_stim];
        centroids_save = centroids(2,1:2);
        Stim_Provide = 'Light';
    elseif stim_detect_izq == 0 && stim_detect_der == 0
        stimulus = 0;
        disp(['"No detected stimulus in video ' name ', try again"'])
    end
    %% Calculate stimulation time
    if stimulus ~= 0
        time = stimulus(1,2)-stimulus(1,1);
        time = time/framerate;
        %% Detect anomalies
        anomalie = stimulus(1,2)-stimulus(1,1);
        anomalie = anomalie/framerate;
        if anomalie >= 5
            disp(['Caution, the stimulation time is greater than 5 sec. in ' 'video ' name])
        elseif anomalie <=2
            disp(['Caution, the stimulation time is less than 2 sec. in ' 'video ' name])
        end
        %% Prepare data for save
        Stimulus.stimulus = stimulus;
        Stimulus.centroids = centroids_save;
        Stimulus.radius_inpixel = radius_inpixel;
        Stimulus.name = name;
        Stimulus.Vid = Vid;
        Stimulus.Stim_Provide = Stim_Provide;
        Stimulus.time_sec = time;
        %% Save
        WorkFolder = cd; cd(path_name);
        save(['Stimulus_Vid.' name '_' Sesion '.mat'],'Stimulus');
        cd(WorkFolder);
        disp(['"Done ' 'video ' name '"'])
    end
    %% To display images of start/end stimulus
    
    % imrefer_inst = vid2mat(:,:,(stimulus(1,1))-1);
    % imrefer_endst = vid2mat(:,:,(stimulus(1,2))+1);
    % figure(2)
    % colormap('gray')
    % subplot(1,2,1)
    % imagesc(imrefer_inst)
    % subplot(1,2,2)
    % imagesc(imrefer_endst)
end
end

