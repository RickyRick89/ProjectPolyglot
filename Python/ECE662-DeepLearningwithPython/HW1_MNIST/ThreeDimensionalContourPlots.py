# -*- coding: utf-8 -*-
"""
Created on Sun Aug 27 15:59:13 2023
https://jakevdp.github.io/PythonDataScienceHandbook/04.12-three-dimensional-plotting.html
@author: johnchiasson
"""
from mpl_toolkits import mplot3d
import numpy as np
import matplotlib.pyplot as plt
import math
pi = math.pi

def f(w1, w2):
    return  0.5*(np.cos(w1)**2 + np.sin(w2)**2)
w1 = np.linspace(-2*pi, 2*pi, 100)
w2 = np.linspace(-2*pi, 2*pi, 100)

W1, W2 = np.meshgrid(w1, w2)
Z = f(W1, W2)

fig = plt.figure(num=1,figsize=[8, 8],edgecolor='red')
ax = plt.axes(projection='3d')
#ax.contour3D(W1, W2, Z, 100, cmap='winter')
#ax.plot_wireframe(W1, W2, Z, color='blue')
ax.plot_surface(W1, W2, Z, rstride=1, cstride=1,cmap='viridis', edgecolor='none')
ax.set(xlim=(-5*pi/2, 5*pi/2), ylim=(-2*pi, 2*pi), zlim=(0.0,1.0),\
       xlabel='w1', ylabel='w2', zlabel='C(w1,w2')
# Placement 0, 0 would be the bottom left, 1, 1 would be the top right.
ax.text2D(0.05, 0.95, "0.5*(np.cos(w1)**2 + np.sin(w2)**2", transform=ax.transAxes)
