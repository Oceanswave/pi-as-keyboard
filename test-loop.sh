#!/bin/bash
counter=1
while [ $counter -le 1000 ]
do
  echo $counter
  sleep 5s
  bash ./test.sh
  ((counter++))
done

echo All Done!
