using Brainfuck

# Use the @DIR macro

buffer = IOBuffer()
brainfuck_interpret("++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.)", stream_out = buffer)
print(buffer)