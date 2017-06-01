CC = gcc

default: 2pl

2pl: 2pl.o syntax.o engine.o storage.o lock_manager.o
	$(CC) 2pl.o syntax.o engine.o storage.o lock_manager.o -o 2pl

2pl.o: 2pl.c syntax.h
	$(CC) -c 2pl.c

engine.o: engine.c engine.h syntax.h storage.h lock_manager.h
	$(CC) -c engine.c

lock_manager.o: lock_manager.c lock_manager.h syntax.h
	$(CC) -c lock_manager.c

syntax.o: syntax.c syntax.h
	$(CC) -c syntax.c

storage.o: storage.c storage.h
	$(CC) -c storage.c

clean:
	-rm -f *.o
	-rm -f 2pl
