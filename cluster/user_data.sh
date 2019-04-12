#!/bin/bash

echo "Hello, Pritesh" > index.html
nohup busybox httpd -f -p "${server_port}" &