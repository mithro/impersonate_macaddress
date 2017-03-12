/*
 * COPYRIGHT (C) 2015 Yann Sionneau <ys@m-labs.hk>
 */ 

#define _GNU_SOURCE

#include <errno.h>
#include <net/if.h>
#include <net/if_arp.h>
#include <sys/ioctl.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <dlfcn.h>

#define ETHER_ADDR_LEN 6

int ioctl(int d, unsigned long request, ...)
{
	va_list myargs;
	struct ifreq *ifr;
	int ret;
	int i;
	char mac_addr_buff[ETHER_ADDR_LEN];
	char *mac_addr;

	va_start(myargs, request);
	mac_addr = getenv("MACADDR");
	sscanf(mac_addr, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx", &mac_addr_buff[0],
           &mac_addr_buff[1], &mac_addr_buff[2], &mac_addr_buff[3],
           &mac_addr_buff[4], &mac_addr_buff[5]);

	//ioctl(3, SIOCGIFNAME, {ifr_index=0, ifr_name=???}) = -1 ENODEV (No such device)
	//ioctl(3, SIOCGIFNAME, {ifr_index=1, ifr_name="lo"}) = 0
	//ioctl(3, SIOCGIFHWADDR, {ifr_name="lo", ifr_hwaddr=00:00:00:00:00:00}) = 0
	//ioctl(3, SIOCGIFNAME, {ifr_index=2, ifr_name="em0"}) = 0
	//ioctl(3, SIOCGIFHWADDR, {ifr_name="em0", ifr_hwaddr=aa:bb:cc:dd:ee:ff}) = 0
	//ioctl(3, SIOCGIFNAME, {ifr_index=3, ifr_name="em1"}) = 0
	//ioctl(3, SIOCGIFHWADDR, {ifr_name="em1", ifr_hwaddr=aa:bb:cc:dd:ee:f1}) = 0

	if(request == SIOCGIFNAME) {
		ifr = va_arg(myargs, struct ifreq *);

		if (ifr->ifr_ifindex == 0) {
			ifr->ifr_name[0] = 'e';
			ifr->ifr_name[1] = 't';
			ifr->ifr_name[2] = 'h';
			ifr->ifr_name[3] = '0';
			ifr->ifr_name[4] = '\0';
			ret = 0;
		} else {
			errno = ENODEV;
			ret = -1;
		}
		va_end(myargs);
		return ret;
	} else if(request == SIOCGIFHWADDR) {
		ifr = va_arg(myargs, struct ifreq *);
		ifr->ifr_hwaddr.sa_family = ARPHRD_ETHER;
		for(i = 0; i < ETHER_ADDR_LEN; i++)
			ifr->ifr_hwaddr.sa_data[i] = mac_addr_buff[i];
		va_end(myargs);
		return 0;
	} else {
		int (*real_ioctl)(int, unsigned long, ...);
		real_ioctl = dlsym(RTLD_NEXT, "ioctl");
		ret = real_ioctl(d, request, myargs);
		va_end(myargs);
		return ret;
	}
}
