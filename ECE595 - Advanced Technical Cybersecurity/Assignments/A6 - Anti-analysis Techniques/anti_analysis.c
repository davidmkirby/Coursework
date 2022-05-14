#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>
#include <sys/ptrace.h>
#include "syscall.h"

bool vmdetect(void){
	unsigned long long t0, t1;
	unsigned junk = 0;
	double fjunk = 0;
	volatile struct{
		int64_t base;
		int16_t offset;
	} a[2] = {0};
	asm("sgdt %0":"=m"(a[0])::);
	asm("sidt %0":"=m"(a[1])::);
	if(((a[0].offset == 0) || (a[0].base > 0)) || ((a[1].offset == 0) || (a[1].base > 0)))
		return true;
	if(&t0 < (unsigned long long*)0x7ff000000000)
		return true;
	t0 = __builtin_ia32_rdtscp(&junk);
	__asm volatile("cpuid"
	              :"=a" (junk),
	               "=b" (junk),
	               "=c" (junk),
	               "=d" (junk)
	);
	t1 = __builtin_ia32_rdtscp(&junk);
	unsigned long long cpuid_time = t1 - t0;
	t0 = __builtin_ia32_rdtscp(&junk);
	__asm volatile("fbstp %0"
	              :"=m" (junk)
	              :"t" (fjunk)
	              :"st"
	);
	t1 = __builtin_ia32_rdtscp(&junk);
	unsigned long long fbstp_time = t1 - t0;
	return (fbstp_time >= cpuid_time) || (cpuid_time > 2000);
}

bool dbdetect(void){
	static unsigned char bss;
	unsigned char *probe = malloc(0x10);
	bool ret = (probe - &bss < 0x20000);
	free(probe);
	if(ret)
		return true;
	int failsafe = 0;
	if((syscall(SYS_ptrace, PTRACE_TRACEME, 0, 0, 0) == -1))
		failsafe = 2;
	if((syscall(SYS_ptrace, PTRACE_TRACEME, 0, 0, 0) == -1))
		failsafe *= 3;
	if(failsafe == 6)
		return true;
	syscall(SYS_ptrace, PTRACE_DETACH, syscall(SYS_getpid), 0, 0);
	return false;
}

int main(){
	int clear = 0;

	if(vmdetect()) {++clear; puts("nice try! (VM detected)");}
	if(dbdetect()) {++clear; puts("nice try! (debugger detected)");}
	if(!clear){puts("no analysis detected.");}
}
