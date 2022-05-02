#include<stdio.h>
#include<string.h>
#include<pthread.h>
#include<stdlib.h>
#include<unistd.h>

pthread_t tid[2];
pthread_mutex_t lock;

void* eat(void *arg)
{
	sleep(rand() % 2);
	pthread_mutex_lock(&lock);
    printf("Person %d eating\n", arg);
	sleep(5);
	pthread_mutex_unlock(&lock);
    return NULL;
}

int main(void)
{
    int err;
	srand(time(NULL));

    for(int i=0;i<2;i++)
    {
        err = pthread_create(&(tid[i]), NULL, &eat, (void*)i);
        if (err != 0)
            printf("\ncan't create thread :[%s]", strerror(err));
    }

    pthread_join(tid[0], NULL);
    pthread_join(tid[1], NULL);

    return 0;
}