#include <torch/torch.h>

#include <iostream>


int main() {
    auto x = torch::randn({5, 3});
    std::cout << x << std::endl;
    return 0;
}