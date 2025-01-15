import csv
import argparse
import pandas as pd

def parse_arguments():
    parser = argparse.ArgumentParser(description='Process washer data.')
    # parser.add_argument('in_use', type=int, help='Indicates if the washing machine is in use (1) or not (0)')
    parser.add_argument('-i', '--in_use', type=str, default="0", help="Filename to process")
    return parser.parse_args()


args = parse_arguments()
is_in_use = int(args.in_use)

print(f"Washing machine in use: {is_in_use}")

def read_washer_data(input_file):
    washer_data = []
    with open(input_file, mode='r') as file:
        csv_reader = csv.DictReader(file)
        for row in csv_reader:
            washer_data.append(row)
    return washer_data

def write_washer_data(output_file, data):
    if not data:
        return

    fieldnames = data[0].keys()
    with open(output_file, mode='w', newline='') as file:
        csv_writer = csv.DictWriter(file, fieldnames=fieldnames)
        csv_writer.writeheader()
        csv_writer.writerows(data)

washer_id = 'RVREB-W1'

input_file = 'machine_state.csv'
output_file = 'machines_state.csv'

states_df = pd.read_csv("machine_state.csv",index_col="machine_id")
# print("\nWash before State",states_df)
device_state = states_df.loc[washer_id]
states_df.at[washer_id, 'is_spin'] = is_in_use
print("\nWash after State",states_df)
states_df.to_csv("machine_state.csv", index_label="machine_id")

