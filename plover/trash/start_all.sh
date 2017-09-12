#!/bin/bash
set -e

# connect to primary machine and run corresponding script on it
ssh user@ip './primary_test.sh' &

# connect to secondary machine and run corresponding script on it
ssh user@ip './secondary_test.sh'
