#!/bin/bash
IFS=' '
arr=($( curl -s "http://192.168.103.100:3000/api/cluster/alias/percona_live" | jq '.[] | select(.ReadOnly==true) .Key.Hostname ,select(.ReadOnly==true)  .Key.Port' | xargs ))
arraylength=${#arr[@]}
# use for loop to read all values and indexes
consul kv delete -recurse mysql/slave/percona_live
for (( i=0; i<${arraylength}; i++ ));
do
  consul kv put mysql/slave/percona_live/${arr[$i]}/ip ${arr[$i]}
  consul kv put mysql/slave/percona_live/${arr[$i]}/port ${arr[(($i+1))]}
  i=$((i+1));
done
