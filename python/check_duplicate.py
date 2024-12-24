import os

def check_duplicates(filepath):
    if not os.path.exists(filepath):
        print(f"File {filepath} does not exist.")
        return

    with open(filepath, 'r') as f:
        # Read all lines and strip newline characters
        data = [line.strip() for line in f if line.strip()]

    # Convert hexadecimal strings to integers
    data_int = [int(value, 16) for value in data]

    # Use a set to identify duplicates
    seen = set()
    duplicates = set()
    for value in data_int:
        if value in seen:
            duplicates.add(value)
        else:
            seen.add(value)

    if duplicates:
        print(f"Duplicates found in {filepath}:")
        for value in duplicates:
            print(f"Value: {value} (Hex: {value:X})")
    else:
        print(f"No duplicates found in {filepath}.")

# Example usage:
# Replace 'your_file_path.dat' with the actual path to your .dat file
filepath = '../dat/n32_N16/golden1.dat'
check_duplicates(filepath)
