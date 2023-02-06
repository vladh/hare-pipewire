.POSIX:
.SUFFIXES:

LIBS=-lpipewire-0.3
VARS=LD_LIBRARY_PATH=/usr/lib:${LD_LIBRARY_PATH}

sine:
	mkdir -p bin
	$(VARS) hare build $(LIBS) -o bin/sine cmd/sine

run:
	$(VARS) hare run $(LIBS) cmd/sine

.PHONY: sine run
