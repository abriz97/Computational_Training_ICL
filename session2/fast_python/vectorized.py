import numpy as np


# Example of vectorized operations
a = np.arange(10000)
b = np.arange(10000)

import time

start = time.time()
c = a + b
print("Vectorized addition took: ", time.time() - start)

start = time.time()
c = [a[i] + b[i] for i in range(10000)]
print("Loop addition took: ", time.time() - start)