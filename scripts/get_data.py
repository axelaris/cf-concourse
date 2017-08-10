#!/usr/bin/env python3
import sys
import yaml
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('yaml_file', nargs='?', type=argparse.FileType('r'), default=sys.stdin)

yaml_file = parser.parse_args().yaml_file
yaml_body = yaml.load(yaml_file.read())
data = yaml.dump(yaml_body['data'], default_flow_style=False)
print(data)

