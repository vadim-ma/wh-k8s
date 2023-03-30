#!/usr/bin/env bash

for item in {m,w}{1..3}; do
    ssh-keygen -R "wh-k8s-${item}"
done
ssh-keygen -R "wh-k8s"

