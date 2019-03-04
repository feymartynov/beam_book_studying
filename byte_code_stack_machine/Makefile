build_interpreter:
	gcc ./interpreter_v2.c -o interpreter_v2 -Wno-unsequenced -Wno-int-to-pointer-cast

compile:
	elixir ./compiler.exs source -o bytecode

run:
	./interpreter_v2 ./bytecode

all: build_interpreter compile run
.PHONY: all
