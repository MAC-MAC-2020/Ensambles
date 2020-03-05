function plot_transitorios_derivada(sigfn)
%% Plot de todas las celulas con su derivada
treshold = 2.5;

for i = 1:size(sigfn,1)
% Normalizar transitorios    
sigfn_ni = normalize(sigfn(i,:));
deri_sigfn_ni = diff(sigfn_ni,[],2);
% sacar SD de los transitorios y multiplicar po 2.5
desest = std(deri_sigfn_ni)*treshold;
xdesest = [1 size(sigfn,2)];
ydesest = [desest desest];

% plot de transitorios y derivada
figure(1)

subplot(2,1,1)
plot(sigfn_ni,'-*','LineWidth',1)
name = ['Transitorios '  'Neurona ' num2str(i)];
xlabel('Frames','FontWeight','bold')
title (name)

subplot(2,1,2)
x = 1:size(sigfn,2)-1;
plot(xdesest,ydesest,'k',x,deri_sigfn_ni,'-* r','LineWidth',1)
xlabel('Frames','FontWeight','bold')
title 'Primera derivada'

pause
end
end