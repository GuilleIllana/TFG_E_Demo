%% Modelo y número de capas a utilizar
modelos={'Sombras lentas', 'Sombras rápidas', 'Sombreado parcial',...
    'Uniforme abrupto', 'Uniforme escalonado', 'Uniforme gradual'};
idx_modelo=6; % Índice del modelo a utilizar
modelo=modelos{idx_modelo}; % Modelo a utilizar
capas=3; % Número de capas a utilizar
name={'5V_5Ir','5V_I','5V_I_Ta','5V_5Ir_I_Ta'}; % Variables a utilizar

%% Simulación
for i=1:numel(name)
    selector=i; % Variable utilizada en Simulink
    filename=strcat('..\Resultados\',modelo,'\ANN_',int2str(capas),'_',name{i});
    ANN=sim('Comparacion_ANN'); % Modelo de Simulink
    save(filename,'ANN'); % Guardado de los resultados 
end






