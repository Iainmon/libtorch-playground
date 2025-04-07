
// require "mylib.h", "-lMyLib";

extern proc wrHello(): void;
extern proc wrHelloTorch(): void;
extern proc sumArray(arr: [] real(32), sizes: [] int(32), dim: int(32)): real(32);

wrHello();

wrHelloTorch();


var dom = {0..<10, 0..<10};
var a: [dom] real(32);
for (idx,i) in zip(dom,0..<dom.size) do
    a[idx] = i:real(32);

var sizes: [0..1] int(32);
sizes[0] = dom.dim(0).size : int(32);
sizes[1] = dom.dim(1).size : int(32);

writeln("Sum of array: ", sumArray(a,sizes,a.rank));
