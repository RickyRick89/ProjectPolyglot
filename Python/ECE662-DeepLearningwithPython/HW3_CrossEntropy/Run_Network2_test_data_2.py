# -*- coding: utf-8 -*-
"""
Created on Sat Sep 24 19:00:48 2022

@author: johnchiasson
"""
import json  #Java Script Object Notation
import sys  #System-specific parameters and functions module
import numpy as np
import MNIST_Loader
import network2

training_data, validation_data, test_data = MNIST_Loader.load_data_wrapper()

net = network2.load('MNIST_CrossEntropy.json')
print()

print()
print('net.cost =', net.cost)
print()
print('accuracy on test data =', net.accuracy(test_data, convert=False))
print()
for k in range(len(net.sizes)-1):
    print("net.weights[{0}].shape = ".format(k), net.weights[k].shape)
    print("net.biases[{0}].shape  = ".format(k), net.biases[k].shape)
    print()