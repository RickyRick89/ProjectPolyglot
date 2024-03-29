# -*- coding: utf-8 -*-
"""
Created on Thu Aug 24 16:12:25 2017

@author: 
Stanford Course CS231n 
Convolutional Neural Networks for Visual Recognition
"""
import numpy as np
import matplotlib.pyplot as plt
pi=np.pi; th0=4*pi/3
N = 100 # number of points per class
D = 2 # dimensionality of the data
K = 3 # number of classes
Xt = np.zeros((N*K,D)) # data matrix (each row = single example)
y = np.zeros(N*K, dtype='uint8') # class labels
for j in range(K):
  ix = range(N*j,N*(j+1))
  r = np.linspace(0.0,1,N) # np.linspace(start,stop,num)   r=radius
  th = np.linspace(j*th0,(j+1)*th0,N) + np.random.randn(N)*0.2 # th=theta
  # np.random.randn(N)*0.2, N samples of Normal RV of mean 0 & var sqrt(0.2)
  Xt[ix] = np.c_[r*np.cos(th), r*np.sin(th)]
  # np_c column stack  -  stacks 1D arrays as columns in a 2D array
  y[ix] = j
# Visualize the data:
plt.scatter(Xt[:, 0], Xt[:, 1], c=y, s=40, marker = "o",cmap=plt.cm.gist_rainbow, linewidths =1.5,edgecolors="k")
# See https://matplotlib.org/examples/color/colormaps_reference.html 
plt.show()
print("Xt.shape and y.shape"), print(Xt.shape,y.shape)
