function Plot_results
% Guardado de las figuras de tensión, intensidad y potencia y obtención 
% de la energía generada en los modelos utilizando redes neuronales.

modelo='Sombras lentas';
layers=[3,6,12];
var={'5V_I','5V_I_Ta','5V_5Ir','5V_5Ir_I_Ta'};
plotnames={'5V I','5V I Ta','5V 5Ir','5V 5Ir I Ta'};
E=[];
I=[];
V=[];
P=[];
name=[];
k=1;
t=0:1e-3:60;
fprintf('Energia:\n');
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
        plotname=strcat('Tensión,',sprintf(' %.0f',(layers(j))),' capas,',' variables: ',plotnames{i});
        figure(k);
        plot(t,V(:,k));
        title(plotname);
        xlabel('t(s)');
        ylabel('V(V)');
        filename=strcat('.\',modelo,'\Tension\',ANN_name_save,'.png');
        saveas(gcf,filename);
        
        % Intensidad
        plotname=strcat('Intensidad,',sprintf(' %.0f',(layers(j))),' capas,',' variables: ',plotnames{i});
        figure(k);
        plot(t,I(:,k));
        title(plotname);
        xlabel('t(s)');
        ylabel('I(A)');
        filename=strcat('.\',modelo,'\Intensidad\',ANN_name_save,'.png');
        saveas(gcf,filename);
        
        % Potencia
        plotname=strcat('Potencia,',sprintf(' %.0f',(layers(j))),' capas,',' variables: ',plotnames{i});
        figure(k);
        plot(t,P(:,k));
        title(plotname);
        xlabel('t(s)');
        ylabel('P(W)');
        filename=strcat('.\',modelo,'\Potencia\',ANN_name_save,'.png');
        saveas(gcf,filename);
        
        % Energía
        fprintf('%.1f J en %s\n',E(end,k),name{k});
        k=k+1;
    end
end
end

