#!/usr/bin/env bash

read -ep "Teardown bootstrap? (y/n) " ANSWER
if [ "$ANSWER" = "Y" ]; then
  echo "Tearing down bootstrap"
fi
