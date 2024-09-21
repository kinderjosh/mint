#!/bin/bash
set -xe
nasm -felf64 -g mint.asm -o mint.o
ld mint.o -o mint
rm mint.o
