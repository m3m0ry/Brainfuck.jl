
struct Op{T}
end

mutable struct Program
    program::Array{DataType,1}
    program_pointer::Int64
    data::Array{Int8,1}
    data_pointer::Int64
end

function lexer(input::String)
    program = DataType[]
    for m in eachmatch(r">|<|\+|-|,|\.|\[|\]", input)
        push!(program, Op{m.match[1]})
    end
    return program
end

function interpret!(::Type{Op{'>'}}, program::Program)
    #info("Op{'>'}")
    program.data_pointer += 1
    program.program_pointer += 1
end

function interpret!(::Type{Op{'<'}}, program::Program)
    #info("Op{'<'}")
    program.data_pointer -= 1
    program.program_pointer += 1
end

function interpret!(::Type{Op{'+'}}, program::Program)
    #info("Op{'+'}")
    program.data[program.data_pointer] += 1
    program.program_pointer += 1
end

function interpret!(::Type{Op{'-'}}, program::Program)
    #info("Op{'-'}")
    program.data[program.data_pointer] -= 1
    program.program_pointer += 1
end

function interpret!(::Type{Op{'.'}}, program::Program)
    #info("Op{'.'}")
    print(Char(program.data[program.data_pointer]))
    program.program_pointer += 1
end

function interpret!(::Type{Op{','}}, program::Program)
    #info("Op{','}")
    program.data[program.data_pointer] = read(STDIN, Char)
    program.program_pointer += 1
end

function interpret!(::Type{Op{'['}}, program::Program)
    #info("Op{'['}")
    if program.data[program.data_pointer] == 0
        prog = program.program
        block = 0
        for ptr = program.program_pointer + 1:length(prog)
            if prog[ptr] == Op{']'}
                if block == 0
                    program.program_pointer = ptr + 1
                    return
                else
                    block -= 1
                end
            elseif prog[ptr] == Op{'['}
                block += 1
            end
        end
    else
        program.program_pointer += 1
    end
end

function interpret!(::Type{Op{']'}}, program::Program)
    #info("Op{']'}")
    prog = program.program
    block = 0
    for ptr = program.program_pointer - 1:-1:1
        if prog[ptr] == Op{'['}
            if block == 0
                program.program_pointer = ptr
                return
            else
                block -= 1
            end
        elseif prog[ptr] == Op{']'}
            block += 1
        end
    end
end

function interpret!(op::Any, program::Program)
    error("Not such intstruction: $op")
end

args = """
Hello world!
++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.
"""
program = Program(lexer(args), 1, zeros(Int64, 30000), 1)

while 1 <= program.program_pointer <= length(program.program)
    interpret!(program.program[program.program_pointer], program)
end
