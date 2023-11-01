#!/bin/bash

# Get the JSON output from Docker network inspect
docker_network_info="$(docker network inspect one_datanode_hadoop_network)"

# Function to extract the URL for a container name
get_container_url() {
    name="$1"
    port="$2"
    ipv4_address=$(echo "$docker_network_info" | jq -r '.[0].Containers[] | select(.Name == "'$name'").IPv4Address' | cut -d'/' -f1)
    if [ -n "$ipv4_address" ]; then
        echo "$name: http://$ipv4_address:$port"
    fi
}
# URLs
namenode_url=$(get_container_url "namenode" 9870)
historyserver_url=$(get_container_url "historyserver" 8188)
resourcemanager_url=$(get_container_url "resourcemanager" 8088)

# Construct URLs for each datanode
datanode1_url=$(get_container_url "datanode1" 9864)
datanode2_url=$(get_container_url "datanode2" 9864)
datanode3_url=$(get_container_url "datanode3" 9864)

# Construct URLs for each nodemanager
nodemanager1_url=$(get_container_url "nodemanager1" 8042)
nodemanager2_url=$(get_container_url "nodemanager2" 8042)
nodemanager3_url=$(get_container_url "nodemanager3" 8042)

# Print the constructed URLs
echo $namenode_url
echo $historyserver_url
echo $resourcemanager_url

# Print the constructed URLs for datanodes
echo $datanode1_url
echo $datanode2_url
echo $datanode3_url

# Print the constructed URLs for nodemanagers
echo $nodemanager1_url
echo $nodemanager2_url
echo $nodemanager3_url
