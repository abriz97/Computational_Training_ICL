from multiprocessing import Pool
import pandas as pd
import numpy as np
import time
import sys


def process_strings(series: pd.Series):
    return series.str.lower().str.replace(' ', '_').str.replace('-', '_')

def process_floats(series: pd.Series):
    return series.str.replace('Unknown', '0.').astype(float).fillna(0)

def generate_str_column() -> pd.Series:
    severity_modifier = np.random.choice(['Low', 'Medium', 'High', 'Unknown'], 10000)
    location = np.random.choice(['Front', 'Back', 'Left', 'Right', 'Unknown'], 10000)
    separator = np.random.choice(['-', '_', ' '], 10000)
    col = np.concatenate([severity_modifier, separator, location], axis=-1)
    return pd.Series(col)

def generate_float_column() -> pd.Series:
    return pd.Series(np.random.choice(['1.0', '2.0', '3.0', 'Unknown'], 10000))


def generate_dataframe(num_str_cols, num_float_cols) -> pd.DataFrame:
    df = pd.DataFrame()
    for i in range(num_str_cols):
        # NOTE: Could this be optimised?
        df[f'str_col_{i}'] = generate_str_column()
    for i in range(num_float_cols):
        df[f'float_col_{i}'] = generate_float_column()
    return df

def apply_func(func, data):
    return func(data)


def starmap(funcs, args, num_workers=4):
    with Pool(num_workers) as pool:
        return pool.starmap(apply_func, zip(funcs, args))
    
def main(n = 100, num_workers=1):
    df = generate_dataframe(n, n)
    funcs = [process_strings] * n + [process_floats] * n
    args = list(df[x] for x  in df.columns)
    results = starmap(funcs, args, num_workers=num_workers)
    return results

if __name__ == '__main__':
    n = int(sys.argv[1])
    num_workers = int(sys.argv[2])
    start = time.time()
    main(n, num_workers)
    print("Total time: ", time.time() - start)