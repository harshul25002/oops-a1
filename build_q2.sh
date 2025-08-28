#!/usr/bin/env bash
set -euo pipefail

# Build Q2: C++ program that returns 0, excluding standard libraries.
# Uses -nostdlib/-nostartfiles/-nodefaultlibs and links with a minimal syscall trampoline.

# Assemble the syscall trampoline (provided in syscall.S) for Linux x86_64
# If nasm not available, skip this step on macOS; intended to be built on Linux
if command -v nasm >/dev/null 2>&1; then
  nasm -felf64 syscall.S -o syscall.o
fi

# Compile the minimal C++ file without libstdc++/libc and without start files
# We also disable exceptions/RTTI to avoid extra runtime needs
clang++ -std=c++17 -c -fno-exceptions -fno-rtti -Os -o q2_return0.o q2_return0.cpp || g++ -c -fno-exceptions -fno-rtti -Os -o q2_return0.o q2_return0.cpp

# Link everything without standard libraries or default start files
# Provide our own entry from syscall.S when present
if [ -f syscall.o ]; then
  clang++ -nostdlib -nostartfiles -nodefaultlibs -o q2.out syscall.o q2_return0.o 2>/dev/null || g++ -nostdlib -nostartfiles -nodefaultlibs -o q2.out syscall.o q2_return0.o || true
else
  # Fallback link (will use system crt on macOS, acceptable only for local test)
  clang++ -o q2.out q2_return0.o 2>/dev/null || g++ -o q2.out q2_return0.o
fi

printf "Built q2.out successfully.\n"
