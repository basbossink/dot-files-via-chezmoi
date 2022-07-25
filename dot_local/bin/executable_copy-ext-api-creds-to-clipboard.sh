#! /usr/bin/sh

cargo run -- ext-api create-account --user-name $(uuid | tr -d '\n') | tail -n 2 | awk '{print $2}' | tr '\n' ':' | sed 's/:$//' | xsel -b
