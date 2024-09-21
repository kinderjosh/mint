# Mint

Mint (short for Minimal Interpreter) is a stack-based programming language similar to [Forth](https://en.wikipedia.org/wiki/Forth_(programming_language)) written in assembly.

## TODO

- [x] - Printing
- [x] - Keywords
- [ ] - Math
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

| Opcode | Purpose |
| --- | --- |
| ```dup``` | Copy the top item on the stack and push it to the stack. |
| ```drop``` | Pop the top item off the stack and discard it. |
| ```out``` | Pop the top item off the stack and print it. |
| ```over``` | Copy the item below the top item on the stack and push it to the stack. |
| ```swap``` | Swap the top two items on the stack. |

## License

Mint is distributed under the MIT license. See [LICENSE](./LICENSE) for details.
