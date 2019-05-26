#!/bin/bash

echo "will start now"

for (( i = 1 ; i <= 10 ; i++ )); do
   sleep 1
   echo "Hello, World $ENV !"
done

echo "will exist now with success"
exit 0
