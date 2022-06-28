#!/bin/bash
cd /opt/cs50/extensions

for file in *
do
    if ["$file"]
    then
        code-server --install-extension $file
    else
        echo "Error: This file does not exist"
    fi
done