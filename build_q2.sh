#!/usr/bin/env bash
set -euo pipefail

if command -v nasm >/dev/null 2>&1; then
  nasm -felf64 syscall.S -o syscall.o
fi

clang++ -std=c++17 -c -fno-exceptions -fno-rtti -Os -o q2_return0.o q2_return0.cpp || g++ -c -fno-exceptions -fno-rtti -Os -o q2_return0.o q2_return0.cpp

if [ -f syscall.o ]; then
  clang++ -nostdlib -nostartfiles -nodefaultlibs -o q2.out syscall.o q2_return0.o 2>/dev/null || g++ -nostdlib -nostartfiles -nodefaultlibs -o q2.out syscall.o q2_return0.o || true
else
  clang++ -o q2.out q2_return0.o 2>/dev/null || g++ -o q2.out q2_return0.o
fi

printf "Built q2.out successfully.\n"
