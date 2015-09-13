LDFLAGS ?= -ldl
RM ?= rm -f
CFLAGS ?= -Wall -Wformat-security -fstack-protector --param=ssp-buffer-size=4 -D_FORTIFY_SOURCE=2 -O2 

all: impersonate_macaddress.so

impersonate_macaddress.so: impersonate_macaddress.o
	$(CC) -shared -o $@ $^ $(LDFLAGS)

impersonate_macaddress.o: impersonate_macaddress.c
	$(CC) -fPIC $(CFLAGS) -c $^

clean:
	$(RM) *.o *.so

.PHONY: all clean
