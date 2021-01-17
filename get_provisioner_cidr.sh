#!/bin/bash
set -e

CIDR=$(dig +short myip.opendns.com @resolver1.opendns.com)
CIDR=`echo $CIDR | sed 's/ *$//g'`
CIDR="$CIDR/32"
result='{"provisioner_cidr":"'"${CIDR}"'"}'
echo $result