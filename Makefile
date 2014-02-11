
SRC = $(wildcard src/*.c)
OBJ = ${SRC:.c=.o}

CC = clang
PREFIX = /usr/local
CFLAGS = -std=c99 -g -O0 -Wno-parentheses -Wno-switch-enum -Wno-unused-value
CFLAGS += -Wno-switch
CFLAGS += -I deps
LDFLAGS += -lm

# linenoise

CFLAGS += -I deps/linenoise
OBJ += deps/linenoise/linenoise.o

TEST_SRC = $(shell find {test,src}/*.c | sed '/luna/d')
TEST_OBJ = ${TEST_SRC:.c=.o}
CFLAGS += -I src

luna: $(OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

%.o: %.c
	@$(CC) -c $(CFLAGS) $< -o $@
	@printf "\e[36mCC\e[90m %s\e[0m\n" $@

test: test_runner test-parser
	@./$<

test-parser:
	@sh test/parser.sh

test_runner: $(TEST_OBJ)
	$(CC) $^ -o $@

install: luna
	install luna $(PREFIX)/bin

uninstall:
	rm $(PREFIX)/bin/luna

clean:
	rm -f luna test_runner $(OBJ) $(TEST_OBJ)

.PHONY: clean test test-parser install uninstall
