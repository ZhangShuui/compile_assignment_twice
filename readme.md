# Simple explanation of my compile procedure

## compile_test1.s
a simple implemention of fibonacci 

The procedure can be divided into two parts 
- **fobo**: the implemention of Recursive function
- **main**: the `main` function
other details that need to be mentioned include:
- the `.global` mark
- the `.word` mark
- when we design a recursive function, we need to pay extra attention to the use of register, otherwise there will be conflict
## compile_test2.s
a simple implemention of combinatorial number (C(m,n)) 

The procedure can be divided into three parts 
- **factorial**: the function that compute factorial
- **C**: the function that combine the results of factorial, then reach the final result(use div function) 
- **main**: the `main` function
other details that need to be mentioned include:
- `__aeabi_idiv`: arm assembly code lacks the `div` instruction, in compensation they have this function to code with the need of divsion.
