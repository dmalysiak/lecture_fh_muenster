
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdlib.h>
#include <stdio.h>

__global__ void addKernel(float*c, const float *a, const float *b)
{
    int threadId = (blockIdx.x * blockDim.x) + threadIdx.x;	
    c[threadId] = a[threadId] + b[threadId];
}

int main()
{
    float *d_a, *d_b, *d_c;
    int N = 512;
    int threadsPerBlock = 256;
    int blocks = N / threadsPerBlock;
    float* a = (float*)malloc(sizeof(float) * N);
    float* b = (float*)malloc(sizeof(float) * N);
    float* c = (float*)malloc(sizeof(float) * N);   

    for (int i = 0; i < N; i++)
    {
        a[i] = i;
        b[i] = i;
    }

    // Allocate device memory for a
    cudaMalloc((void**)&d_a, sizeof(float) * N);
    cudaMalloc((void**)&d_b, sizeof(float) * N);
    cudaMalloc((void**)&d_c, sizeof(float) * N);
    // Transfer data from host to device memory
    cudaMemcpy(d_a, a, sizeof(float) * N, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, sizeof(float) * N, cudaMemcpyHostToDevice);



    // Add vectors in parallel.
    addKernel <<< blocks, threadsPerBlock >>> (d_c, d_a, d_b);
    cudaDeviceSynchronize();
    cudaError_t cudaStatus = cudaGetLastError();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "addKernel launch failed: %s\n", cudaGetErrorString(cudaStatus));
    }
    cudaMemcpy(c, d_c, sizeof(float) * N, cudaMemcpyDeviceToHost);

    for (int i = 0; i < N; i++)
    {
        printf("%f ,", c[i]);
    }

    cudaFree(d_c);
    cudaFree(d_a);
    cudaFree(d_b);
    free(a);
    free(b);
    free(c);

    // cudaDeviceReset must be called before exiting in order for profiling and
    // tracing tools such as Nsight and Visual Profiler to show complete traces.
    cudaStatus = cudaDeviceReset();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceReset failed!");
        return 1;
    }

    return 0;
}

