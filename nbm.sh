#!/bin/bash

usage="usage : ./nbm.sh [ --install -u <ssh user> -n <nextcloud host> -b <backup host> ]\n\t\t [ --restore -u <ssh user> -b <backup host> ]"
args=""

for arg in $*; do
    if [ $arg != "--install" ] && [ $arg != "--restore" ]; then
        args="$args $arg"
    fi
done

echo
echo ">> unlock ssh keys for single sign-on ..."
eval `ssh-agent` >/dev/null && ssh-add &>/dev/null
echo

if [ $1 == "--install" ]; then
    source cli/install.sh $args
elif [ $1 == "--restore" ]; then
    source cli/restore.sh $args
else
    echo -e "$usage"
fi
