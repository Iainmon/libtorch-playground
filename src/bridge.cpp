#include "bridge.h"
#include <torch/torch.h>

int baz() {
    auto x = torch::randn({5, 3});
    return x.size(0);
}