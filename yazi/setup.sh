#!/bin/bash

CURRENT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
CURRENT_PWD="$(pwd)/${CURRENT_PATH}"

ya pkg install
ya pkg upgrade

