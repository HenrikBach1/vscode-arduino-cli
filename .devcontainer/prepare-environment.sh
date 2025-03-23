#!/bin/bash
file="prepare-environment.sh"

# Ensure required mount directories exist
mkdir -p /projects 2>/dev/null || true
mkdir -p /workspace 2>/dev/null || true
mkdir -p /workspaces 2>/dev/null || true
mkdir -p ${PWD}/.cache 2>/dev/null || true

echo "Environment prepared for container creation."
