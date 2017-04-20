from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
from numpy import genfromtxt
import sys

data = genfromtxt(sys.argv[1], delimiter=',')

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

sp = ax.scatter(data[:, 0], data[:, 1], data[:, 2], s=20, c=data[:, 3])
plt.colorbar(sp)
ax.set_xlabel(r'$p_x$');
ax.set_ylabel(r'$p_y$');
ax.set_zlabel(r'$\theta$');
plt.show()
