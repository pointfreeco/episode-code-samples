/*:
 # Higher-Order Functions Exercises

 1. Write `curry` for functions that take 3 arguments.
 */
// TODO
/*:
 2. Explore functions and methods in the Swift standard library, Foundation, and other third party code, and convert them to free functions that compose using `curry`, `zurry`, `flip`, or by hand.
 */
// TODO
/*:
 3. Explore the associativity of function arrow `->`. Is it fully associative, _i.e._ is `((A) -> B) -> C` equivalent to `(A) -> ((B) -> C)`, or does it associate to only one side? Where does it parenthesize as you build deeper, curried functions?
 */
// TODO
/*:
 4. Write a function, `uncurry`, that takes a curried function and returns a function that takes two arguments. When might it be useful to un-curry a function?
 */
// TODO
/*:
 5. Write `reduce` as a curried, free function. What is the configuration _vs._ the data?
 */
// TODO
/*:
 6. In programming languages that lack sum/enum types one is tempted to approximate them with pairs of optionals. Do this by defining a type `struct PseudoEither<A, B>` of a pair of optionals, and prevent the creation of invalid values by providing initializers.

    This is “type safe” in the sense that you are not allowed to construct invalid values, but not “type safe” in the sense that the compiler is proving it to you. You must prove it to yourself.
 */
// TODO
/*:
 7. Explore how the free `map` function composes with itself in order to transform a nested array. More specifically, if you have a doubly nested array `[[A]]`, then `map` could mean either the transformation on the inner array or the outer array. Can you make sense of doing `map >>> map`?
 */
// TODO
