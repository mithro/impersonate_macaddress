LDFLAGS ?= -ldl
RM ?= rm -f
CFLAGS ?= -Wall -Wformat-security -fstack-protector --param=ssp-buffer-size=4 -D_FORTIFY_SOURCE=2 -O2 

all: impersonate_macaddress.so  impersonate_macaddress32.so

impersonate_macaddress.so: impersonate_macaddress.o
	$(CC) -shared -o $@ $^ $(LDFLAGS)

impersonate_macaddress.o: impersonate_macaddress.c
	$(CC) -fPIC $(CFLAGS) -o $@ -c $^

impersonate_macaddress32.so: impersonate_macaddress32.o
	$(CC) -m32 -shared -o $@ $^ $(LDFLAGS)

impersonate_macaddress32.o: impersonate_macaddress.c
	$(CC) -m32 -fPIC $(CFLAGS) -o $@ -c $^

clean:
	$(RM) *.o *.so

.PHONY: all clean
