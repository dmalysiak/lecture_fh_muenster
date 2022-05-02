#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>

int main() {
    pid_t parent = getpid();
	pid_t pid = fork();

	if (pid == -1)
	{
		printf("Failed to fork\n");
	} 
	else if (pid > 0)
	{
		int status;
		printf("Parent: waiting for child\n");
		waitpid(pid, &status, 0);
		printf("Parent: child finished work\n");
	}
	else 
	{
		printf("Child: sleeping for 5s\n");
		sleep(5);
		printf("Child: woke up\n");
	}
    return 0;
}