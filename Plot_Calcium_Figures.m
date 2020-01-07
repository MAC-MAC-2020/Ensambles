%% Plot Calcium Figures %%

%% Moises AC 07.sep.2019

%% Start

figure(2)
clf

%%% raw max %%%
subplot(2, 3, 1, 'align')
imagesc(imaxn)
axis square
title('Raw')

%%% neural enhanced before movement correction %%%
subplot(2, 3, 2, 'align')
imagesc(imaxy)
axis square
title('Before MC')

%%% neural enhanced after movement correction %%%
subplot(2, 3, 3, 'align')
imagesc(imax)
axis square
title('After MC')

%%% contour %%%
subplot(2, 3, 4, 'align')
plot_contour(roifn, sigfn, seedsfn, imrefer_max, pixh, pixw)
axis square

%% movement measurement %%%
subplot(2, 3, 5, 'align')
axis off
%if ismc
    plot(raw_score); hold on; plot(corr_score); hold off;
    axis square
    title('MC Scores')
%else
    %title('MC skipped')
%end

%% all identified traces %%%
subplot(2, 3, 6, 'align')
sigt = sigfn;
sigt = sigt(1:50,:);
for i = 1: size(sigt, 1)
    sigt(i, :) = normalize(sigt(i, :));
end
plot((sigt + (1: size(sigt, 1))')')
axis tight
axis square
title('Traces')
