#! /usr/bin/env python3

import argparse
import sys
import getopt
import os
import re


def get_arguments():
    """ create argument parser for command line args """
    parser = argparse.ArgumentParser()
    parser.add_argument('-t', '--template', required=True)
    parser.add_argument('-v', '--vcf', required=True)
    parser.add_argument('-p', '--output_prefix', required=True)
    parser.add_argument('-s', '--hpo_id', action='append')
    parser.add_argument('-o', '--output_file', required=True)
    parser.add_argument('-b', '--proband', default='')
    parser.add_argument('-d', '--ped', default='')
    
    return parser

def main(argv):
    """ 
        do it all - get arguments, determine run values, read template file
        and substitute in real values for placeholders
    """

    parser = get_arguments()
    args = parser.parse_args()

    # set dict for replacements            
    replacements = {'<output_prefix>': args.output_prefix, 
                    '<hpo_ids>' : args.hpo_id,
                    '<vcf>' : args.vcf,
		    '<proband>' : args.proband,
		    '<ped>' : args.ped }
    
    # read template file and replace placeholder vals
    with open(args.output_file, 'w') as o:
        with open(args.template, 'r') as f:
            for line in f:
                for k in replacements.keys():
                    line = line.rstrip().replace(k, str(replacements[k]))
                    
                o.write(line + "\n")


if __name__ == "__main__":
    main(sys.argv[1:])
