=======
# OOPD Assignment 1

This repository contains solutions for the three tasks described in the assignment.

## Contents
- `q2_return0.cpp`: Minimal C++ program that returns 0.
- `syscall.S`: Minimal Linux x86_64 entry and syscall trampoline used to avoid standard libraries.
- `prompt.S`: NASM x86_64 program (no C/C++ libs) that:
  - Asks for name and age
  - Validates that age is a number
  - Asks for confirmation `y/n`
  - Prints whether confirmed
- `build_q2.sh`: Builds question 2 using g++ options that exclude standard libraries.
- `build_q3.sh`: Builds question 3 (`prompt.S`) using nasm and ld directly.
- `.gitignore`: Ensures no binaries or libraries are committed.

## Build prerequisites
- Linux x86_64 environment (for syscalls and static linking)
- `nasm`, `ld`, `g++`

Note: macOS uses different syscall ABIs. Please build and run on Linux or a Linux container/VM.

## Build and run
### Q2
```bash
chmod +x build_q2.sh
./build_q2.sh
./q2.out; echo $?   # Should print 0 as exit code
```

### Q3
```bash
chmod +x build_q3.sh
./build_q3.sh
./prompt.out
```

Sample interaction (Q3):
```
Enter your name: Alice
Enter your age: 23
Confirm (y/n): y
Confirmed: name=Alice, age=23
```
If non-numeric age is entered, the program will report an error and exit.

## Submission notes
- No standard C/C++ libraries, templates, or STL are used.
- Timestamps are preserved via Git commits.
- Only sources and build scripts are committed (no binaries or libraries).
>>>>>>> 90ea630 (Assignment setup: README, q2_return0.cpp, prompt.S, build scripts, gitignore)
