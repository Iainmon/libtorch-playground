// require "-llibtorchbridge";
require "-ltorchbridge";

extern proc baz(): int;

writeln(baz());