function Plot_results_PO
% Guardado de las figuras de tensión, intensidad y potencia y obtención 
% de la energía generada en los modelos utilizando P&O.

load('.\Sombras lentas\PO');
E=out.E;
I=out.I;
V=out.V;
P=out.P;
t=0:1e-3:60;
fprintf('Energia:\n');
fprintf('%.1f J en P&O\n',E(end));

plotname='Tensión, P&O';
figure(1);
plot(t,V(:));
title(plotname);
xlabel('t(s)');
ylabel('V(V)');
filename=strcat('.\Sombras lentas\Tension\','P&O','.png');
saveas(gcf,filename);

plotname='Intensidad, P&O';
figure(2);
plot(t,I(:));
title(plotname);
xlabel('t(s)');
ylabel('I(A)');
filename=strcat('.\Sombras lentas\Intensidad\','P&O','.png');
saveas(gcf,filename);

plotname='Potencia, P&O';
figure(3);
plot(t,P(:));
title(plotname);
xlabel('t(s)');
ylabel('P(W)');
filename=strcat('.\Sombras lentas\Potencia\','P&O','.png');
saveas(gcf,filename);
end

