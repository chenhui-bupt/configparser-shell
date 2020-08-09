#!/bin/bash
DIRNAME=$(cd $(dirname $0); pwd)
source $DIRNAME/configparser.sh

input_path=$(config_parser 'JOB' 'input_path')
output_path=$(config_parser 'JOB' 'output_path')
echo 'input_path: '$input_path
echo 'output_path: '$output_path
exit 0
