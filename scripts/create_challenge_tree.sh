#!/bin/sh
set -eu

TARGET_DIR="${1:-ctf-web-challenge}"

mkdir -p "${TARGET_DIR}/build/src"
mkdir -p "${TARGET_DIR}/build/service"
mkdir -p "${TARGET_DIR}/build/config"
mkdir -p "${TARGET_DIR}/final"

: > "${TARGET_DIR}/build/dockerfile"
: > "${TARGET_DIR}/readme.md"
: > "${TARGET_DIR}/wp.md"

echo "created: ${TARGET_DIR}"
echo "files:"
echo "  ${TARGET_DIR}/build/src/"
echo "  ${TARGET_DIR}/build/service/"
echo "  ${TARGET_DIR}/build/config/"
echo "  ${TARGET_DIR}/build/dockerfile"
echo "  ${TARGET_DIR}/final/"
echo "  ${TARGET_DIR}/readme.md"
echo "  ${TARGET_DIR}/wp.md"
