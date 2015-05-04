import numpy as np
import matplotlib.pyplot as plt

conf_arr = [[1.2755, 2.7361, 1.2714, 0.9830, 4.1541],
            [2.5298, 0.6931, 4.0714, 1.2554, 2.9263],
            [3.4954, 0.7465, 1.2176, 3.0802, 2.7486],
            [4.4545, 1.2875, 4.6463, 2.3664, 4.5860],
            [4.7965, 4.2036, 1.7499, 1.7583, 1.4292]]

#conf_arr = np.random.random((5, 5))*5

norm_conf = []
for i in conf_arr:
    a = 0
    tmp_arr = []
    a = sum(i, 0)
    for j in i:
        tmp_arr.append(float(j)/float(a))
    norm_conf.append(tmp_arr)

fig = plt.figure()
plt.clf()
ax = fig.add_subplot(111)
ax.set_aspect(1)
res = ax.imshow(np.array(norm_conf), cmap=plt.cm.jet,
                interpolation='nearest')

width = len(conf_arr)
height = len(conf_arr[0])

'''for x in xrange(width):
    for y in xrange(height):
        ax.annotate(str(conf_arr[x][y]), xy=(y, x),
                    horizontalalignment='center',
                    verticalalignment='center')'''

cb = fig.colorbar(res)

plt.xticks(np.arange(0, 5), ['A', 'B', 'C', 'D', 'E'])
plt.yticks(np.arange(0, 5), ['F', 'G', 'H', 'I', 'J'])

#plt.xticks([], [])
#plt.yticks([], [])

#alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
#plt.xticks(range(width), alphabet[:width])
#plt.yticks(range(height), alphabet[:height])

plt.show()

plt.savefig('confusion_matrix.png', format='png')