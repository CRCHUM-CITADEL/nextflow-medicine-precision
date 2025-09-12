#!/usr/bin/env python3
import argparse
import os

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', type=str, required=True)
    args = parser.parse_args()

    input_file = args.input
    if not os.path.exists(input_file):
        raise FileNotFoundError(f"File does not exist: {input_file}")

    # write to the current working directory using just the basename
    base = os.path.basename(input_file)
    output_file = f"{base}_reversed_python.txt"

    with open(input_file, 'r') as f:
        lines = f.readlines()

    with open(output_file, 'w') as f:
        f.writelines(reversed(lines))

    print(f"Reversed file saved as: {output_file}")

if __name__ == '__main__':
    main()
