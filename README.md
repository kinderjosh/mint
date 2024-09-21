# Mint

Mint (short for Minimal Interpreter) is a stack-based programming language similar to [Forth](https://en.wikipedia.org/wiki/Forth_(programming_language)) written in assembly.

## TODO

- [x] - Printing
- [x] - Keywords
- [x] - Math
- [ ] - Conditions
- [ ] - Functions?

## Example

Source:

```
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

### Keywords

| Name | Purpose |
| --- | --- |
| ```drop``` | Pop the top item off the stack and discard it. |
| ```dup``` | Copy the top item on the stack and push it to the stack. |
| ```over``` | Copy the item below the top item on the stack and push it to the stack. |
| ```out``` | Pop the top item off the stack and print it. |
| ```swap``` | Swap the top two items on the stack. |

### Arithmetic

Like Forth, Mint uses [Reverse Polish notation](https://en.wikipedia.org/wiki/Reverse_Polish_notation).

```
10 2 / out
```

Is the same as:

```py
print(10 / 2)
```

## License

Mint is distributed under the MIT license. See [LICENSE](./LICENSE) for details.
