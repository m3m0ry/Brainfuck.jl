using Brainfuck

# Use the @DIR macro

buffer = PipeBuffer()
brainfuck_interpret("++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.", stream_out = buffer)
s = readstring(buffer)
print(s)
if s != "Hello World!\n"
    print("help")
end