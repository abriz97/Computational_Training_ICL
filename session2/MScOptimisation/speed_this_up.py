""" 
A script that reads in a csv file, performs a series of operations on the rows 
of the csv file and outputs the transformed data to a new csv file. 
"""

#!/usr/bin/env python3
# USAGE: ./speed_this_up.py </PATH/TO/DATA.csv> 

import argparse
import pandas as pd
import sys 

def myfunc1(df):
    # Initialize an empty DataFrame with the required columns
    results_loop = pd.DataFrame(columns=['summed_prod'])
    
    # Iterate over each row in the DataFrame
    for _, row in df.iterrows():
        new_value = (row['int_column'] + row['float32_column']) * row['float64_column']
        # Create a new DataFrame for the current row's result
        new_row = pd.DataFrame({'summed_prod': [new_value]})
        # Concatenate the new row to the results DataFrame
        results_loop = pd.concat([results_loop, new_row], ignore_index=True)
    
    return results_loop

def process_rows_numpy(dataframe):
    # Read the CSV file
    df = pd.read_csv(dataframe)
    
    # Using NumPy 
    int_data = df['int_column'].values
    float32_data = df['float32_column'].values
    float64_data = df['float64_column'].values
    
    results_numpy = (int_data + float32_data) * float64_data

    return results_numpy


def myfunc2(df):
    # Initialize an empty DataFrame with the required columns
    return_df = pd.DataFrame(columns=['multiply_col', 'my_bool'])

    # Iterate over each row in the DataFrame
    for index, row in df.iterrows():
        if row.iloc[0] > 2:
            # Multiply column 2 and column 4
            multiply_col_value = row.iloc[1] * row.iloc[3]
            
            # Determine the value for 'my_bool'
            my_bool_value = 10 if row.iloc[4] else -10
            
            # Create a new DataFrame for the current row's result
            new_row = pd.DataFrame({'multiply_col': [multiply_col_value], 'my_bool': [my_bool_value]})
            # Concatenate the new row to the return DataFrame
            return_df = pd.concat([return_df, new_row], ignore_index=True)
    
    return return_df

def main():
    # Read the input file name from command line arguments
    input_file = sys.argv[1]

    # Read the CSV file into a DataFrame
    df = pd.read_csv(input_file)

    # Time the process_rows_loop function
    output1 = myfunc1(df)
    output1.to_csv('output1.csv', index=False)

    # Time the myfunc2 function
    output2 = myfunc2(df)
    output2.to_csv('output2.csv', index=False)

if __name__ == "__main__":
    main()


