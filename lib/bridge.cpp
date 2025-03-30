#include <bridge.h>


int baz(void) {
    auto x = torch::randn({5, 3});
    return x.size(0);
}