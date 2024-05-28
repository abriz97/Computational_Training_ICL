"""
Script to find the area of a circle using random sampling.
"""
import time
from random_area.utils.calc import area_of_circle


def main():
    tic = time.time()

    # TODO: Seed the random number generator

    for experiment in range(10):
        radius = 1.0
        num_samples = 1000
        area = area_of_circle(radius, num_samples)
        # TODO: Log below instead of printing
        print(f"Experiment {experiment + 1}: The area of the circle is {area:.4f}")

    toc = time.time()
    print(f"Time taken: {toc - tic:.4f} s")