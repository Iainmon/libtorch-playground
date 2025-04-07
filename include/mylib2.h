#ifndef MYLIB2_H
#define MYLIB2_H
#include <stdio.h>

#ifdef __cplusplus
#include <torch/torch.h>
#include <iostream>
extern "C" {
#endif


void wrHello(void);

void wrHelloTorch(void);

#ifdef __cplusplus
}
#endif

#endif // MYLIB2_H
