#!/usr/bin/env bash

while true
do
  STATUS=$(curl -s -o /dev/null -w '%{http_code}' https://gateway.$TF_VAR_cluster_name.$TF_VAR_zone_domain/deployment-service/actuator/health)
  if [ $STATUS -eq 200 ]; then
    echo "Got $STATUS! :-) Env is ready to receive traffic!"
    break
  else
    echo "Got $STATUS :( Env not ready yet!"
  fi
  sleep 10
done



