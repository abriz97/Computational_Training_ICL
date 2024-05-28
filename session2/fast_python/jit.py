from numba import jit
import numpy as np

@jit(nopython=True)
def add(a, b):
    return a + b

def add_no_jit(a, b):
    return a + b

@jit(nopython=True)
def complex_calc(a, b):
    return 2 * a * b + a**2 + b**2

def complex_calc_no_jit(a, b):
    return 2 * a * b + a**2 + b**2

a = np.arange(10000)
b = np.arange(10000)

import time

def test_jit(func, func_no_jit):
    start = time.time()
    c = func(a, b)
    inital_time = time.time()
    print("JIT compile + func took: ", inital_time - start)
    c = func(a, b)
    print("JIT func took: ", time.time() - inital_time)

    start = time.time()
    c = func_no_jit(a, b)
    print("No JIT compile took: ", time.time() - start)

print("Testing add")
test_jit(add, add_no_jit)

print("Testing complex_calc")
test_jit(complex_calc, complex_calc_no_jit)