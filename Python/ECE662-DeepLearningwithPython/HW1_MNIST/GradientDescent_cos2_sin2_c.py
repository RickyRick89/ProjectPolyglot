# -*- coding: utf-8 -*-
"""
Created on Sat Aug 26 18:36:03 2023
from:
https://realpython.com/gradient-descent-algorithm-python/
https://matplotlib.org/stable/tutorials/introductory/pyplot.html
https://www.w3schools.com/python/matplotlib_grid.asp
"""

import matplotlib as mpl
import numpy as np
import matplotlib.pyplot as plt
from numpy import linalg as LA
import math
from math import cos, sin
pi = math.pi

def grad(v):
    return np.array([cos(v[0])*sin(-v[0]),sin(v[1])*cos(v[1])])

def gradient_descent(gradient, start, learn_rate, n_iter=25, tolerance=1e-3):
    
    descent = np.copy(start)

    for _ in range(n_iter):
        diff = -learn_rate * gradient(start)
        if np.all(np.abs(diff) <= tolerance):
            break
        start += diff
        descent = np.vstack((descent, start))     
      
    return descent

# C(x,y) = 0.5*(np.cos(x)**2 + np.sin(y)**2)
    
descent = gradient_descent(gradient=grad,start=np.array([2.0,2.0]), learn_rate=0.1)

xx, yy = np.meshgrid(np.arange(-5*pi/2,7*pi/2,pi),np.arange(-2*pi,3*pi,pi))
fig = plt.figure(num=1,figsize=[6, 6],edgecolor='red')
plt.scatter(xx, yy,s=40, cmap='winter')
plt.plot(descent[:,0],descent[:,1],'o')
plt.show(block=False)


