import os
import tensorflow as tf
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Dense, Flatten, Dropout, BatchNormalization
from tensorflow import keras
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

import tensorflow as tf


physical_devices = tf.config.list_physical_devices('GPU')
try:
    tf.config.experimental.set_memory_growth(physical_devices[0], True)
except:
    pass




dataset_path = '.\data'
data_path_V = os.path.join(dataset_path, 'Vmodtable.csv')
data_path_I = os.path.join(dataset_path, 'Imodtable.csv')
data_path_Results = os.path.join(dataset_path, 'Resultstable.csv')

column_names_V = ['V1', 'V2', 'V3', 'V4', 'V5']
column_names_I = ['I1', 'I2', 'I3', 'I4', 'I5']
column_names_Results = ['Vmp', 'Imp']

raw_dataset_V = pd.read_csv(data_path_V, names=column_names_V, na_values='?', comment='\t', sep=',')
raw_dataset_I = pd.read_csv(data_path_I, names=column_names_I, na_values='?', comment='\t', sep=',')
dataset_results = pd.read_csv(data_path_Results, names=column_names_Results, na_values='?', comment='\t', sep=',')

dataset = pd.concat([raw_dataset_V, raw_dataset_I], axis=1)

train_dataset = dataset.sample(frac=0.8, random_state=0)  # 80% de datos para entrenamiento
test_dataset = dataset.drop(train_dataset.index)

train_results = dataset_results.pop('Vmp')

train_labels = train_results[train_dataset.index]
test_labels = train_results.drop(train_dataset.index)

loss, mae, mse = model.evaluate(test_dataset, test_labels)
print('Testing set MAE: {:5.2f} V'.format(mae))
print('Testing set MSE: {:5.2f} V'.format(mse))