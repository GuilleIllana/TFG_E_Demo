function Plot_results_all
% Guardado de las figuras de tensión, intensidad y potencia y obtención 
% de la energía generada en los modelos utilizando redes neuronales.
clc;
modelos={'Sombras lentas', 'Sombras rápidas', 'Sombreado parcial',...
    'Uniforme abrupto', 'Uniforme escalonado', 'Uniforme gradual'};
idx_modelo=6;
modelo=modelos{idx_modelo};

% Saving the energy values
diary Energia
diary on

layers=[3,6,12];
var={'5V_I','5V_I_Ta','5V_5Ir','5V_5Ir_I_Ta'};
plotnames={'5V, I','5V, I, Ta','5V, 5Ir','5V, 5Ir, I, Ta'};
E=[];
I=[];
V=[];
P=[];
titles=[];
name=[];
k=1;
t=0:1e-3:60;
h=[];

file_Ir=strcat('.\',modelo,'\Ir');
load(file_Ir);
Ir=out.Ir;

file=strcat('.\',modelo,'\PO');
load(file);
t=0:1e-3:60;

fprintf('\nEnergia en modelo %s:\n', modelo);
for i=1:numel(var)
    for j=1:numel(layers)
        
        % Obtención de los datos
        ANN_name_aux=strcat('.\',modelo,'\ANN_',sprintf('%.0f',(layers(j))),'_',var{i}); 
        ANN_name_save=strcat('ANN_',sprintf('%.0f',(layers(j))),'_',var{i});      
        load(ANN_name_aux);
        name=[name,string(ANN_name_save)];
        
        E_aux=ANN.E;
        E=[E,E_aux];
        I_aux=ANN.I;
        I=[I,I_aux];
        V_aux=ANN.V;
        V=[V,V_aux];
        P_aux=ANN.P;
        P=[P,P_aux];
        
        % Tensión
        figure(i*3-2);
        %yyaxis left
        subplot(4,1,[2;4]);
        plot(t,V(:,k),'LineWidth',4,'LineStyle','-');
        xlabel('t(s)');
        ylabel('V(V)');
        hold on;
        filename=strcat('.\',modelo,'\Tension\',ANN_name_save,'.png');
        %saveas(figure(i*3-2),filename);
        
        % Intensidad
        figure(i*3-1);
        %yyaxis left
        subplot(4,1,[2;4]);
        plot(t,I(:,k),'LineWidth',4,'LineStyle','-');
        xlabel('t(s)');
        ylabel('I(A)');
        hold on;
        filename=strcat('.\',modelo,'\Intensidad\',ANN_name_save,'.png');
        %saveas(figure(i*3-1),filename);
        
        % Potencia
        figure(i*3);
        %yyaxis left
        subplot(4,1,[2;4]);
        plot(t,P(:,k),'LineWidth',4,'LineStyle','-');
        xlabel('t(s)');
        ylabel('P(W)');
        ylim([0,1650]);
        hold on;
        filename=strcat('.\',modelo,'\Potencia\',ANN_name_save,'.png');
        %saveas(figure(i*3),filename);
        
        % Energía
        fprintf('%.1f Wh en %s\n',E(end,k)/3600,name{k});
        k=k+1;
    end

    I_PO=out.I;
    V_PO=out.V;
    P_PO=out.P;
    
    % Tensión
    figure(i*3-2);
    %yyaxis left
    subplot(4,1,[2;4]);
    plot(t,V_PO,'LineWidth',4,'LineStyle','-');
    
    % Intensidad
    figure(i*3-1);
    %yyaxis left
    subplot(4,1,[2;4]);
    plot(t,I_PO,'LineWidth',4,'LineStyle','-');
    
    % Potencia
    figure(i*3);
    %yyaxis left
    subplot(4,1,[2;4]);
    plot(t,P_PO,'LineWidth',4,'LineStyle','-');
    
    % Tensión
    plotname=strcat('Tensión (',modelo,'): ANN (',plotnames{i},') vs. P&O');
    titles=[titles,string(plotname)];

    % Intensidad
    plotname=strcat('Intensidad (',modelo,'): ANN (',plotnames{i},') vs. P&O');
    titles=[titles,string(plotname)];


    % Potencia
    plotname=strcat('Potencia (',modelo,'): ANN (',plotnames{i},') vs. P&O');
    titles=[titles,string(plotname)];
   
end
E_PO=out.E;

% Energía
fprintf('%.1f Wh en P&O\n',E_PO(end)/3600);
diary off
% Ajuste de las gráficas
for l=1:3*numel(var)
    figure(l);
    subplot(4,1,[2;4]);
    if(mod(l,3)==0)
        P_perf = (-4e-8).*(Ir.^3) + (7e-5).*(Ir.^2) + 1.5153.*Ir - 8.9462;
        plot(t,P_perf,'LineWidth',2,'LineStyle','--','Color','r');
        %plot(t,Ir*1.6,'LineWidth',2,'LineStyle','--','Color','r');
        set(gca,'FontSize',38);
        legend({'3 capas', '6 capas', '12 capas','P&O','Ideal'},'Location','southeast','FontSize',30);
    else
        set(gca,'FontSize',38);
        legend({'3 capas', '6 capas', '12 capas','P&O'},'Location','southeast','FontSize',30);
    end
    
    subplot(4,1,1);
    plot(t,Ir,'LineWidth',2,'LineStyle','--','Color','r');
    title(titles{l});
    ylabel('Ir (W/m2)');
    ylim([0,1200]);
    set(gca,'FontSize',38);
    
%    set(gca,'FontSize',50)
%     yyaxis right
%     ylabel('Irradiancia (W/m2)','Color','r');
%     set(gca,'ycolor','r')
    
   
end
% figure(3*numel(var)+1)
% plot(t,Ir,'LineWidth',2,'LineStyle','-','Color','r');
% ylim([0,1200]);
% % title(modelo);
% xlabel('t(s)');
% ylabel('Ir(W/m2)');
% set(gca,'FontSize',50);
end

