import pandas as pd

# create the default machine states

# Define machine IDs and column names
machine_ids = ['RVREB-D6', 'RVREB-D1', 'RVREB-W6', 'RVREB-W1', 'RVREB-D4', 'RVREB-W3', 'RVREB-W8', 'RVREB-W4', 'RVREB-W5', 'RVREB-W2', 'RVREB-D5', 'RVREB-D2', 'RVREB-D3', 'RVREB-W7']
columns = ["is_idle", "is_in_use", "is_spin", "has_clothes", "last_time_stamp"]

# Create an empty DataFrame with machine IDs as the index and specified columns
df = pd.DataFrame(0, index=machine_ids, columns=columns, dtype=int)

# Set the 'last_time_stamp' column to zero
df['last_time_stamp'] = '20240101-000000'  # Set to a default datetime value

# Display the DataFrame
df.to_csv("machine_state.csv", index_label="machine_id")
# Format 'last_time_stamp' column as %Y%m%d-%H%M%S
df['last_time_stamp'] = pd.to_datetime(df['last_time_stamp'], format='%Y%m%d-%H%M%S')
df['is_idle'] = 1
# Display the DataFrame
print(df)
df.to_csv("machine_state.csv", index_label="machine_id")
