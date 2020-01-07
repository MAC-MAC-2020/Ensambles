function footprints = footprint_v_beta(imax,x,y)

%Se nececita mejorar, porque los footprints se van acumulando en la misma
%imagen.

size_neuron = 4;
edges_footprint = 11;
limits =  ((edges_footprint - 1)/2);

imax_zeros = zeros(size(imax,1),size(imax,2));
footprints = zeros(size(imax,1),size(imax,2),length(x));

for i = 1:length(x)    

cox = x(i); 
coy = y(i);

row1 = (coy-limits); 
row2 = (coy+limits);
col1 = (cox-limits);
col2 = (cox+limits);

footprint = imax( row1:row2, col1:col2 );
imax_zeros( row1:row2, col1:col2 ) = footprint;
footprints(:,:,i) = imax_zeros;
end

for ii = 1:length(x)
imagesc(footprints(:,:,ii))
axis square
pause
hold on
end

for j = 1:length(x)
plot(x(j),y(j),'o')
hold on
end
hold off  
end