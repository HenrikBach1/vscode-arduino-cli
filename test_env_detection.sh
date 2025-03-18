#!/bin/bash
file="test_env_detection.sh"

# Test environment detection
if [ -n "$CODESPACES" ]; then
    echo "Environment detected: Codespaces"
else
    echo "Environment detected: Local Machine"
fi
