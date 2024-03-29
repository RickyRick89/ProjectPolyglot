import matplotlib as mpl
import numpy as np
import matplotlib.pyplot as plt
from numpy import linalg as LA
import math
from math import cos, sin
pi = math.pi

def grad(v):
    return np.array([cos(v[0])*sin(-v[0]),sin(v[1])*cos(v[1])])

def gradient_ascent(gradient, start, learn_rate, n_iter=25, tolerance=1e-3):
    
    ascent = np.copy(start)

    for _ in range(n_iter):
        diff = learn_rate * gradient(start)
        if np.all(np.abs(diff) <= tolerance):
            break
        start += diff
        ascent = np.vstack((ascent, start))     
      
    return ascent

# C(x,y) = 0.5*(np.cos(x)**2 + np.sin(y)**2)
    
ascent = gradient_ascent(gradient=grad,start=np.array([2.0,2.0]), learn_rate=0.1)

xx_new, yy_new = np.meshgrid(np.arange(-5*pi/2 + pi/2, 7*pi/2, pi), np.arange(-2*pi + pi/2, 3*pi, pi))
fig = plt.figure(num=1,figsize=[6, 6],edgecolor='red')
plt.scatter(xx_new, yy_new,s=40, cmap='winter')
plt.plot(ascent[:,0],ascent[:,1],'o')
plt.show(block=False)


