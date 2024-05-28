import random

def area_of_circle(radius, num_samples):
    """
    Function to find the area of a circle using random sampling.

    Parameters
    ----------
    radius : float
        Radius of the circle.
    num_samples : int
        Number of random samples to use.

    Returns
    -------
    float
        Area of the circle.
    """
    count_inside = 0
    for _ in range(num_samples):
        x = random.uniform(-radius, radius)
        y = random.uniform(-radius, radius)
        if x**2 + y**2 <= radius**2:
            count_inside += 1
    return count_inside / num_samples * (2 * radius)**2