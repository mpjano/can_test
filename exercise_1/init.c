#include <stdio.h>
#include <unistd.h>

int main() {
    char* const arg[]={"bin/sh",NULL};
	char* const argp[]={"PATH=/",NULL};
    printf("Hello world\n");

    execve("busybox",arg,argp);

    while(1);
}