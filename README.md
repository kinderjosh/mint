# Mint

Mint (short for Minimal Interpreter) is a stack-based programming language similar to [Forth](https://en.wikipedia.org/wiki/Forth_(programming_language)) written in assembly.

## TODO

- [x] - Printing
- [x] - Keywords
- [x] - Math
- [x] - Variables

## Example

> [!NOTE]
> Syntax highlighting for Vim/Neovim is available in the [editor](#editor) section.

Source:

```mint
12 10 over out out out
```

Output:

```console
$ ./mint example.mint
12
10
12
```

## Quick Start

- Prerequisites: [nasm](https://nasm.us/)

```bash
git clone https://github.com/kinderjosh/mint.git
cd mint
./build.sh
```

## Language Reference

### Notes

- Items left on the stack are automatically popped when the program exits and won't cause a segmentation fault.

### Keywords

| Name | Purpose |
| --- | --- |
| ```drop``` | Pop the top item off the stack and discard it. |
| ```dup``` | Copy the top item on the stack and push it to the stack. |
| ```<variable> load ``` | Extracts the value within ```<variable>``` and pushes it to the stack. |
| ```over``` | Copy the item below the top item on the stack and push it to the stack. |
| ```out``` | Pop the top item off the stack and print it. |
| ```<variable> store``` | Pops the top item off the stack and stores it into ```<variable>```. |
| ```swap``` | Swap the top two items on the stack. |

### Arithmetic

Like Forth, Mint uses [Reverse Polish notation](https://en.wikipedia.org/wiki/Reverse_Polish_notation).

Arithmetic operators pop the top two items and push the result of the operation.

```mint
10 2 / out
```

This program basically does:

```c
printf("%ld\n", 10 / 2);
```

### Variables

The characters a-k are parsed as variables.

Variables are pushed as pointers, not as values.

```mint
a b
```

This program pushes a pointer to ```a``` and a pointer to ```b```.

Use the ```store``` and ```load``` keywords to access the values within variables.

An example to initialize, divide two variables and print the result:

```mint
64 a store
8 b store

a load
b load
/ out
```

This program basically does:

```c
long a, b;

a = 64;
b = 8;

printf("%ld\n", a / b);
```

## Editor

Syntax highlighting is currently only available for Vim/Neovim.

### Vim

```bash
mkdir -p ~/.vim/syntax/
cp ./mint.vim ~/.vim/syntax/
```

Then add the following line to your vimrc:

```vim
autocmd BufNewFile,BufRead *.mint set filetype=mint
```

### Neovim

```bash
mkdir -p ~/.config/nvim/syntax/
cp ./mint.vim ~/.config/nvim/syntax/
```

Then add the following line to your init file:

VimScript:

```vim
autocmd BufNewFile,BufRead *.mint set filetype=mint
```

Lua:

```lua
vim.cmd('autocmd BufNewFile,BufRead *.mint set filetype=mint')
```

## License

Mint is distributed under the MIT license. See [LICENSE](./LICENSE) for details.
