#include <mylib2.h>

extern "C" void wrHello(void) {
    printf("Hello from wrHello!\n");
}


extern "C" void wrHelloTorch(void) {
    printf("Hello from wrHelloTorch!\n");
    auto t = torch::ones({2, 3});
    std::cout << t << std::endl;
}