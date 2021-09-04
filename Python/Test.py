import os
import tensorflow as tf
from tensorflow.keras.layers import Dense
from tensorflow import keras
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from tensorflow.keras import backend as K

def read_data(data_path, column_names):
    print(len(data_path))
    try:
        for x in range(len(data_path)):
            if x == 0: dataset = pd.read_csv(data_path[x], names=column_names[x], na_values='?', comment='\t', sep=',')
            else:
                raw_data_aux = pd.read_csv(data_path[x], names=column_names[x], na_values='?', comment='\t', sep=',')
                dataset = pd.concat([dataset, raw_data_aux], axis=1)
    except:
        dataset = pd.read_csv(data_path, names=column_names, na_values='?', comment='\t', sep=',')
    return dataset

def shuffle(data, n_ini=1, n_fin=1, axis=0):
    data = data.copy()
    for n in range(n_ini, n_fin+1):
        data.apply(np.random.shuffle, axis=axis)
    return data

def build_model(dataset):
    model = keras.models.Sequential()
    model.add(Dense(64, activation='relu', input_shape=[len(dataset.keys())])) # Keys son los titulos de los datos
    model.add(Dense(64, activation='relu'))
    model.add(Dense(64, activation='relu'))
    model.add(Dense(64, activation='relu'))
    model.add(Dense(64, activation='relu'))
    model.add(Dense(1))
    return model

def norm(x):
    return (x - train_stats['mean']) / train_stats['std']

def plot_history(history):
    hist = pd.DataFrame(history.history)
    hist['epoch'] = history.epoch
    plt.figure()
    plt.xlabel('Epoch')
    plt.ylabel('Mean Square Error (MSE)')
    plt.plot(hist['epoch'], hist['mse'], label='Train Error')
    plt.plot(hist['epoch'], hist['val_mse'], label='Validation Error')
    plt.ylim([0, 20])
    plt.legend()
    plt.show()

if __name__ == "__main__":
    """# Avoid GPU collapse
    physical_devices = tf.config.list_physical_devices('GPU')
    try:
        tf.config.experimental.set_memory_growth(physical_devices[0], True)
    except:
        pass"""

    dataset_path = '.\data'
    data_path_Vmod = os.path.join(dataset_path,'Vmodtable.csv')
    data_path_Imod = os.path.join(dataset_path, 'Imodtable.csv')
    data_path_Results = os.path.join(dataset_path, 'Resultstable.csv')
    data_path_Ir = os.path.join(dataset_path, 'Irtable.csv')
    data_path_VI = os.path.join(dataset_path, 'VItable.csv')
    data_path_T = os.path.join(dataset_path, 'Ttable.csv')

    column_names_Vmod = ['V1', 'V2', 'V3', 'V4', 'V5']
    column_names_Imod = ['I1', 'I2', 'I3', 'I4', 'I5']
    column_names_Results = ['Vmp', 'Imp']
    column_names_Ir = ['Ir1', 'Ir2','Ir3', 'Ir4','Ir5']
    column_names_VI = ['V', 'I']
    column_names_T = ['Ta', 'Tc']

    nset = 4
    data_path = [None] * nset
    name = [None] * nset
    column_names = [None] * nset
    dataset = [None] * nset

    # 1er Set: (V1, V2, V3, V4, V5, I)
    name[0] = '5V_I'
    data_path[0] = [data_path_Vmod, data_path_VI]
    column_names[0] = [column_names_Vmod, column_names_VI]
    dataset[0] = read_data(data_path[0], column_names[0])
    dataset[0] = dataset[0].drop(['V'], axis=1)

    # 2do Set: (V1, V2, V3, V4, V5, Ir1, Ir2, Ir3, Ir4, Ir5)
    name[1] = '5V_5Ir'
    data_path[1] = [data_path_Vmod, data_path_Ir]
    column_names[1] = [column_names_Vmod, column_names_Ir]
    dataset[1] = read_data(data_path[1], column_names[1])

    # 3er Set: (V1, V2, V3, V4, V5, I1, I2, I3, I4, I5)
    name[2] = '5V_5I'
    data_path[2] = [data_path_Vmod, data_path_Imod]
    column_names[2] = [column_names_Vmod, column_names_Imod]
    dataset[2] = read_data(data_path[2], column_names[2])

    # 4er Set: (V1, V2, V3, V4, V5, I, Ta)
    name[3] = '5V_I_Ta'
    data_path[3] = [data_path_Vmod, data_path_VI, data_path_T]
    column_names[3] = [column_names_Vmod, column_names_VI, column_names_T]
    dataset[3] = read_data(data_path[3], column_names[3])
    dataset[3] = dataset[3].drop(['V'], axis=1)

    print(dataset)

    # Resultados
    dataset_results = read_data(data_path_Results, column_names_Results)
    train_results = dataset_results.pop('Vmp')
    print(train_results)

    """for i in range(nset):
        train_dataset = dataset[i].sample(frac=0.8, random_state=0) # 80% de datos para entrenamiento, combina filas
        test_dataset = dataset[i].drop(train_dataset.index)

        train_labels = train_results[train_dataset.index]
        test_labels = train_results[test_dataset.index]

        # Guardar el Modelo
        print(name[i])

        # Guardar el modelo (.h5)
        save_name = name[i] + '.h5'
        print(save_name)"""
