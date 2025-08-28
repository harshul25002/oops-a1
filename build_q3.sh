#!/usr/bin/env bash
set -euo pipefail

nasm -felf64 prompt.S -o prompt.o
ld -static -o prompt.out prompt.o

printf "Built prompt.out successfully.\n"
