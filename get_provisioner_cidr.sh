#!/bin/bash
set -e

CIDR=$(hostname -I)
CIDR=`echo $CIDR | sed 's/ *$//g'`
CIDR="$CIDR/32"
result='{"provisioner_cidr":"'"${CIDR}"'"}'
echo $result