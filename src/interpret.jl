struct Op{T}
end

mutable struct Program
    program::Array{DataType,1}
    program_pointer::Int64
    data::Array{UInt8,1}
    data_pointer::Int64
    stream_in::IO
    stream_out::IO
end

function lexer(input::String)
    program = DataType[]
    for m in eachmatch(r"[><+\-,.\[\]]", input)
        push!(program, Op{m.match[1]})
    end
    return program
end

function interpret!(::Type{Op{'>'}}, program::Program)
    program.data_pointer += 1
    program.program_pointer += 1
end

function interpret!(::Type{Op{'<'}}, program::Program)
    program.data_pointer -= 1
    program.program_pointer += 1
end

function interpret!(::Type{Op{'+'}}, program::Program)
    program.data[program.data_pointer] += UInt8(1)
    program.program_pointer += 1
end

function interpret!(::Type{Op{'-'}}, program::Program)
    program.data[program.data_pointer] -= UInt8(1)
    program.program_pointer += 1
end

function interpret!(::Type{Op{'.'}}, program::Program)
    write(program.stream_out, program.data[program.data_pointer])
    program.program_pointer += 1
end

function interpret!(::Type{Op{','}}, program::Program)
    if eof(program.stream_in)
        program.data[program.data_pointer] = 0
    else
        program.data[program.data_pointer] = read(program.stream_in, Char)
    end
    program.program_pointer += 1
end

function interpret!(::Type{Op{'['}}, program::Program)
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

function interpret!(op::Any, program::Program) # TODO this is dangerous. It may create lots of functions
    error("Not such intstruction: $op")
end


function brainfuck_interpret(s::String; stream_in::IO = STDIN, stream_out::IO = STDOUT)
    program = Program(lexer(s), 1, zeros(Int64, 30000), 1, stream_in, stream_out)

    while 1 <= program.program_pointer <= length(program.program)
        interpret!(program.program[program.program_pointer], program)
    end
end

function brainfuck_interpret(file::IO; stream_in::IO = STDIN, stream_out::IO = STDOUT)
    brainfuck_interpret(readstring(file), stream_in=stream_in, stream_out=stream_out)
end
