.POSIX:
.SUFFIXES:

LIBS=-lpipewire-0.3
VARS=LD_LIBRARY_PATH=/usr/lib:${LD_LIBRARY_PATH}

sine:
	mkdir -p bin
	$(VARS) hare build $(LIBS) -o bin/sine cmd/sine

podtest:
	mkdir -p bin
	gcc -Wall -g podtest.c -o bin/podtest -lm -I/usr/include/pipewire-0.3 -I/usr/include/spa-0.2 -D_REENTRANT -lpipewire-0.3

tutorial4:
	mkdir -p bin
	gcc -Wall -g tutorial4.c -o bin/tutorial4 -lm -I/usr/include/pipewire-0.3 -I/usr/include/spa-0.2 -D_REENTRANT -lpipewire-0.3

run:
	$(VARS) hare run $(LIBS) cmd/sine

.PHONY: sine run
