LDFLAGS ?= -ldl
RM ?= rm -f
CFLAGS ?= -Wall -Wformat-security -fstack-protector --param=ssp-buffer-size=4 -D_FORTIFY_SOURCE=2 -O2 

all: lib64impersonate_macaddress.so  libimpersonate_macaddress.so

lib64impersonate_macaddress.so: impersonate_macaddress64.o
	$(CC) -m64 -shared -o $@ $^ $(LDFLAGS)

impersonate_macaddress64.o: impersonate_macaddress.c
	$(CC) -m64 -fPIC $(CFLAGS) -o $@ -c $^

libimpersonate_macaddress.so: impersonate_macaddress32.o
	$(CC) -m32 -shared -o $@ $^ $(LDFLAGS)

impersonate_macaddress32.o: impersonate_macaddress.c
	$(CC) -m32 -fPIC $(CFLAGS) -o $@ -c $^

clean:
	$(RM) *.o *.so

.PHONY: all clean
