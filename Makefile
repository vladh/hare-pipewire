.POSIX:
.SUFFIXES:

LIBS=-lpipewire-0.3
VARS=LD_LIBRARY_PATH=/usr/lib:${LD_LIBRARY_PATH}

bin/sine:
	mkdir -p bin
	$(VARS) hare build $(LIBS) -o bin/sine cmd/sine

bin/podtest:
	mkdir -p bin
	$(VARS) hare build $(LIBS) -o bin/podtest cmd/podtest

bin/ podinspect:
	mkdir -p bin
	gcc -Wall -g podinspect.c -o bin/podinspect -lm -I/usr/include/pipewire-0.3 -I/usr/include/spa-0.2 -D_REENTRANT -lpipewire-0.3

bin/tutorial4:
	mkdir -p bin
	gcc -Wall -g tutorial4.c -o bin/tutorial4 -lm -I/usr/include/pipewire-0.3 -I/usr/include/spa-0.2 -D_REENTRANT -lpipewire-0.3

run:
	$(VARS) hare run $(LIBS) cmd/podtest

.PHONY: run
