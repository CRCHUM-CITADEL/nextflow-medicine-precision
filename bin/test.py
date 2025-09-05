#!/usr/bin/env python3
import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', type=str, required=True)
    
    args = parser.parse_args()

    print("Printing the contents of the file using Python!")
    with open(args.input, 'r') as f:
        content = f.read()
    print(content)

if __name__ == '__main__':
    main()