function ANN_save
% Convierte los modelos de Keras almacenados en archivos .h5 en redes
% neuronales DAG para guardarlas en un archivo .mat y puedan ser utilizadas
% por Simulink

%% Data preparation
name = '5V_5Ir_I_Ta'; % 5V_I 5V_5Ir 5V_I_Ta 5V_5Ir_I_Ta
layers='12_layers'; % 3_layers 6_layers 12_layers

keras_name = strcat('.\modelos_keras\',layers,'\',name);
matlab_name = strcat('.\modelos_matlab\',layers,'\',name);

%% Import and transform the ANN
%layers = importKerasLayers(keras_name)
red = importTensorFlowNetwork(keras_name);
save(matlab_name,'red');
end
















% layers = importTensorFlowLayers(keras_name)
% %lgraph = layerGraph(layers);
% lgraph=layers;
% placeholder = findPlaceholderLayers(lgraph)
% new_layer = regressionLayer('Name','routput')
% lgraph = replaceLayer(lgraph,placeholder.Name,new_layer)
% red = assembleNetwork(lgraph)

