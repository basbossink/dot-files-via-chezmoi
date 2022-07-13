#! /usr/bin/sh

cargo run -- ext-api create-account | rg '^[^0-9].+: ' | awk '{print $2}' | tr '\n' ':' | sed 's/:$//' | xsel -b
