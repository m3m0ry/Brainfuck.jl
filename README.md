# Brainfuck.jl

Yet another Brainfuck interpreter in Julia.

Install with `Pkg.clone("https://github.com/m3m0ry/Brainfuck.jl.git")`.

This implementation follows [wikipedia](https://en.wikipedia.org/wiki/Brainfuck).

### Implementation details:
* Cell is `UInt8` large
* Array is `30,000` long
* An `EOF` will put `0` to the current cell.
