#!/usr/bin/env bash
set -euo pipefail

# Build Q3: Assemble and link the pure-assembly program (no libc)

nasm -felf64 prompt.S -o prompt.o
ld -static -o prompt.out prompt.o

printf "Built prompt.out successfully.\n"
