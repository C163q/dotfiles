#!/bin/bash

CURRENT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"
CURRENT_PWD="$(pwd)/${CURRENT_PATH}"

ya pkg add yazi-rs/flavors:dracula
ya pkg add yazi-rs/plugins:full-border

