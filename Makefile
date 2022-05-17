.PHONY : all

all: libsnapshotter.so
   
libsnapshotter.so: libsnapshotter.o
	$(CC) $(LIBFLAG) -o $@ $<
   
libsnapshotter.o: snapshotter.c
	$(CC) -c $(CFLAGS) -I$(LUA_INCDIR) $< -o $@
