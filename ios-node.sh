#!/bin/bash

source ~/.bash_profile

# Kill any existing Swarm agent
# echo "Killing any previous Swarm agent..."
# pkill -f 'java.*swarm-client.jar'

# Wait for a second to ensure the process is terminated
sleep 1

# Start the new Swarm agent
echo "Starting new Swarm agent..."

java -jar swarm-client.jar \
    -master http://localhost:8080/ \
    -username <JENKINS_USER> \
    -password <JENKINS_PASSWORD> \
    -name macos-node \
    -labels "macos" \
    -executors 5 \
