function centroids = Extract_Centroids(pixh,pixw,seedsfn)

[y, x] = ind2sub([pixh, pixw], seedsfn);
centroids(:,1) = x;
centroids(:,2) = y;

end
%% Moises AC 02.dic.2019