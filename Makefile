LDFLAGS ?= -ldl
RM ?= rm -f
CFLAGS ?= -Wall -Wformat-security -fstack-protector --param=ssp-buffer-size=4 -D_FORTIFY_SOURCE=2 -O2 -g

all: setup

setup: impersonate_macaddress32.so  impersonate_macaddress64.so
	# RedHat style directories
	mkdir -p lib
	cp impersonate_macaddress32.so lib/libimpersonate_macaddress.so
	mkdir -p lib64
	cp impersonate_macaddress64.so lib64/libimpersonate_macaddress.so
	# Debian style directories
	mkdir -p lib/i386-linux-gnu
	cp impersonate_macaddress32.so lib/i386-linux-gnu/libimpersonate_macaddress.so
	mkdir -p lib/x86_64-linux-gnu
	cp impersonate_macaddress64.so lib/x86_64-linux-gnu/libimpersonate_macaddress.so
	# Echo the environ settings
	@echo "export LD_PRELOAD=libimpersonate_macaddress.so"
	@echo "export LD_LIBRARY_PATH='${PWD}/\$$LIB'"

impersonate_macaddress64.so: impersonate_macaddress64.o
	$(CC) -m64 -shared -o $@ $^ $(LDFLAGS)

impersonate_macaddress64.o: impersonate_macaddress.c
	$(CC) -m64 -fPIC $(CFLAGS) -o $@ -c $^

impersonate_macaddress32.so: impersonate_macaddress32.o
	$(CC) -m32 -shared -o $@ $^ $(LDFLAGS)

impersonate_macaddress32.o: impersonate_macaddress.c
	$(CC) -m32 -fPIC $(CFLAGS) -o $@ -c $^

clean:
	$(RM) *.o *.so
	$(RM) -rf lib*

.PHONY: all clean
