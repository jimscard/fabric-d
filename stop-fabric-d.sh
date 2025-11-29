#!/bin/bash
# Stop the Fabric server container
if [ "$(docker ps -q -f name=fabric-server)" ]; then
    echo "Stopping Fabric server container..."
    if docker stop fabric-server; then
        echo "Fabric server container stopped."
    else
        echo "Failed to stop Fabric server container."
        exit 1
    fi
fi

if [ "$(docker ps -a -q -f name=fabric-server)" ]; then
    echo "Removing Fabric server container..."
    docker rm fabric-server
fi