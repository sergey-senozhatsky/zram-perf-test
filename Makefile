#
# Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
#

INC = src/include/
MEM = src/
BIN = bin

MKDIR_P = mkdir -p
CFLAGS = -O2
LDFLAGS =

all:
	$(MKDIR_P) $(BIN)
	$(CC) -I$(INC) $(CFLAGS) $(MEM)/bin-mem-hogger.c -o $(BIN)/bin-mem-hogger

clean:
	$(RM) $(BIN)/*
