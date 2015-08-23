#!/bin/sh

# Get Deps
apt-get install -y git

# Clone example source tree and build
git clone https://github.com/en0/webskel2.git
cd webskel2
docker build -t webskel:latest .

cd ..
rm -r webskel2

cat >> webskel-task.json << EOF
{
    "cmd": "supervisord -n",
    "container": {
        "docker": {
            "type": "DOCKER",
            "image": "webskel:latest",
            "network": "BRIDGE",
            "parameters": [],
            "portMappings": [
                { "containerPort": 5000, "hostPort": 0, "protocol": "tcp", "servicePort": 80 }
            ]
        }
    },
    "id": "webskel",
    "cpus": 0.25,
    "instances": 1,
    "mem": 32,
    "ports": [ 0 ]
}
EOF

cat >> launch-task << EOF
#!/usr/bin/env bash
curl -H "content-type: application/json" -X POST -d @webskel-task.json http://localhost:8080/v2/apps/
EOF
