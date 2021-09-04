%% Parámetros de configuración
clc;
clear;
Tonc=45;
niteraciones=3000; % Número de iteraciones
nmodulos=5; % Número de módulos
load('./data/Datos_irradiacion','Data');

%% Carga de datos anteriores
try   
    Vmod_table=readmatrix('./data/Vmodtable.csv');
    Imod_table=readmatrix('./data/Imodtable.csv');
    VI_table=readmatrix('./data/VItable.csv');
    Results_table=readmatrix('./data/Resultstable.csv');
    Ir_table=readmatrix('./data/Irtable.csv');
    T_table=readmatrix('./data/Ttable.csv');
catch
    fprintf(2,'No se encontraron datos previos.\nCreando tablas de resultados...\n');
    Vmod_table=[];
    Imod_table=[];
    VI_table=[];
    Results_table=[];
    Ir_table=[];
    T_table=[];
end

%% Bucle de recolección de datos
% Selección de mes/día/hora
r=unique(round((size(Data,1)-1).*rand(niteraciones,1) + 1));
while niteraciones > numel(r)
    r(end+1)=round((size(Data,1)-1)*rand + 1);
    r=unique(r);
end

for i=1:niteraciones
    tic;
    fprintf('Iteración %d de %d\n\n',i,niteraciones);
    
    % Creación de parámetros de simulación
    Irmax=Data.Global(r(i));
    Irmin=Data.Difusa(r(i));
    Ir=Irmin+(Irmax-Irmin).*rand(nmodulos,1);
    nmod_max=round(rand*(nmodulos-1)+1);
    Ir(nmod_max)=Irmax;
    Ta=Data.Ta(r(i));
    G=mean(Ir);
    T=Ta+G*((Tonc-20)/800);
    
    % Muestra de datos por pantalla
    fprintf('Datos:\n');
    fprintf('Temperatura ambiente: %f ºC\n',Ta);
    fprintf('Temperatura del panel: %f ºC\n',T);
    for j=1:size(Ir,1)
        fprintf('Irradiancia del módulo %d: %f W/m2\n',j,Ir(j));
    end
    fprintf('Irradiancia media: %f W/m2\n',G);
    
    try
        sim('Modelo_irradiancia_parcial'); % Modelo de simulink
        
        % Vmod e Imod
        Vmod_table_aux=[V1,V2,V3,V4,V5]; 
        Imod_table_aux=[I1,I2,I3,I4,I5];
               
        % Vmp e Imp (Resultados)      
        Results_table_aux=zeros(size(V1,1),2); 
        Results_table_aux(:,1)=Vmp;
        Results_table_aux(:,2)=Imp; 
        
        % V e I
        VI_table_aux=[V,I];
                
        % Ir
        Ir_table_aux=zeros(size(Vmod_table_aux,1),nmodulos);
        for k=1:size(Ir)
            Ir_table_aux(:,k)=Ir(k);   
        end   
   
        % T
        T_table_aux=zeros(size(VI_table_aux,1),2);
        T_table_aux(:,1)=Ta;
        T_table_aux(:,2)=T;
        
        % Unión de tablas
        Vmod_table=[Vmod_table;Vmod_table_aux];
        Imod_table=[Imod_table;Imod_table_aux];
        Results_table=[Results_table;Results_table_aux];
        Ir_table=[Ir_table;Ir_table_aux];
        T_table=[T_table;T_table_aux];
        VI_table=[VI_table;VI_table_aux];
        
        % Impresión de resultados
        fprintf('\nResultados:\nVmp = %f\nImp = %f\nnúmero de datos: %d\n',...
        Vmp,Imp,size(V,1));     

    catch
        fprintf(2,'\nError en la simulación número %d, fallo en simulink\n',i);
    end
    toc;
    
    if(~(size(VI_table,1) == size(Ir_table,1)))
        error('Table size not equal');
    end   
    
    clear Vmod_table_aux Imod_table_aux Results_table_aux Ir_table_aux ...
    T_table_aux VI_table_aux V1 V2 V3 V4 V5 I1 I2 I3 I4 I5 V I Vmp Imp Ir ...
    T Ta Pmax Pglobal Irmax Irmin G Vglobal
    fprintf('\n------------------------------------------------------------\n\n');
end

%% Guardado de las tablas
writematrix(Vmod_table,'./data/Vmodtable.csv','Delimiter',','); 
writematrix(Imod_table,'./data/Imodtable.csv','Delimiter',',');
writematrix(VI_table,'./data/VItable.csv','Delimiter',',');
writematrix(Results_table,'./data/Resultstable.csv','Delimiter',',');
writematrix(Ir_table,'./data/Irtable.csv','Delimiter',',');
writematrix(T_table,'./data/Ttable.csv','Delimiter',',');