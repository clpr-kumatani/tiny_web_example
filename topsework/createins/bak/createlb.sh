#!/bin/bash

mussel load_balancer create \
--balance-algorithm leastconn \
--engin haproxy \
--instance-port 80 \
--instance-protocol http \
--max-connection 1000 \
--port 80 \
--protocol http \
--display-name lb80
