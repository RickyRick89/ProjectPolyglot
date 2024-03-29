import numpy as np
import matplotlib.pyplot as plt
import math
from sympy import symbols, cos, sin, hessian, pprint
pi = math.pi

x, y = symbols('x y')
C = 0.5*(cos(x)**2 + sin(y)**2)
H = hessian(C, (x, y))

print('-----------hessian-----------------')
pprint(H)
print('')

xx, yy = np.meshgrid(np.arange(-5*pi/2, 7*pi/2, pi), np.arange(-2*pi, 3*pi, pi))
critical_points = list(zip(xx.ravel(), yy.ravel()))

print('------------critical_points-------------')
pprint(critical_points)
print('')

local_minima = []

for point in critical_points:
    point_dict = {x: point[0], y: point[1]}
    H_at_point = H.subs(point_dict)
    eigenvalues = [float(val.evalf()) for val in H_at_point.eigenvals()]
    if all(val > 0 for val in eigenvalues):
        print(f"The point {point} is a local minimum.")
        local_minima.append(point)

fig = plt.figure(num=1, figsize=[6, 6], edgecolor='red')
plt.scatter(xx, yy, s=40)
plt.title('Given Points')
plt.show(block=False)

fig = plt.figure(num=2, figsize=[6, 6], edgecolor='red')
local_minima_x, local_minima_y = zip(*local_minima)
plt.scatter(local_minima_x, local_minima_y, color='red', s=40)
plt.title('Local Minima')
plt.show(block=False)
