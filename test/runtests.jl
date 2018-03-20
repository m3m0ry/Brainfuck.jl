import Brainfuck

# TODO syntax:
#+++++[>+++++++>++<<-]>.>.[
#Should ideally give error message "unmatched [" or the like, and not give
#any output. Not essential.
#
#+++++[>+++++++>++<<-]>.>.][
#Should ideally give error message "unmatched ]" or the like, and not give
#any output. Not essential.

function main()
    totest = ["hello_world", "bubble_sort", "number_warp", "eof", "obscure", "rot13", "end_of_array"]

    for dir in totest
        dir = joinpath(@__DIR__, dir)
        if isdir(dir)
            for file in readdir(dir)
                file = joinpath(dir, file)
                if isfile(file) && splitext(file)[2] == ".bfk"
                    info("Testing:", file)
                    buffer = PipeBuffer()
                    input = STDIN
                    input_file = joinpath(dir, "input")
                    if isfile(input_file)
                        input = open(input_file)
                    end
                    open(file) do f
                        Brainfuck.brainfuck_interpret(f, stream_in = input, stream_out = buffer)
                    end
                    if isfile(input_file)
                        close(input)
                    end
                    output_file = joinpath(dir, "output")
                    if isfile(output_file)
                        open(output_file) do f
                            Test.@test readstring(buffer) == readstring(f)
                        end
                    end
                end
            end
        end
    end
end

main()