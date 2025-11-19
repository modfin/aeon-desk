#!/bin/bash


curl https://raw.githubusercontent.com/modfin/aeon-desk/refs/heads/master/setup.sh | bash

sudo transactional-update pkg in podman-compose

## distrobox enter tumbleweed -- sudo zypper --non-interactive install 

