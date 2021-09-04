function Plot_irradiancia
% Guardado de las figuras de tensión, intensidad y potencia y obtención 
% de la energía generada en los modelos utilizando redes neuronales.

file=strcat('.\out.mat');
load(file);

t=0:1e-3:60;
Sombras_lentas=out.Sombras_lentas;
Sombras_rapidas=out.Sombras_rapidas;
Sombreado_parcial=out.Sombreado_parcial;
Uniforme_abrupto=out.Uniforme_abrupto;
Uniforme_escalonado=out.Uniforme_escalonado;
Uniforme_gradual=out.Uniforme_gradual;


plot_escenario(Uniforme_abrupto,t,1);
plot_escenario(Uniforme_escalonado,t,2);
plot_escenario(Uniforme_gradual,t,3);
plot_escenario(Sombras_lentas,t,4);
plot_escenario(Sombras_rapidas,t,5);
plot_escenario(Sombreado_parcial,t,6);
   
end

function plot_escenario(Ir_data,t,n_fig)
titles={'Uniforme abrupto','Uniforme escalonado','Uniforme gradual','Sombras lentas',...
    'Sombras rápidas', 'Sombreado parcial'};
for i=1:5
    % Irradiancia
    figure(n_fig);
    %yyaxis left
    plot(t,Ir_data(:,i),'LineWidth',4,'LineStyle','-');
    xlabel('t(s)');
    ylabel('Ir (W/m2)');
    hold on;
end
if n_fig==6
    figure(n_fig);
    title(titles{n_fig});
    set(gca,'FontSize',38);
    legend({'Módulos 1, 2 y 3', 'Módulos 2', 'Módulos 1, 2 y 3','Módulo 4','Módulos 4 y 5'},'Location','southeast','FontSize',30);
else
    figure(n_fig);
    title(titles{n_fig});
    set(gca,'FontSize',38);
    legend({'Módulo 1', 'Módulo 2', 'Módulo 3','Módulo 4','Módulo 5'},'Location','southeast','FontSize',30);
end
end

