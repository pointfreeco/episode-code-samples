/*:
 # Domain Specific Languages: Part 1

 ## Exercises

 1.) Improve the simplify function to also recognize the following patterns:

 - Factorize the `c` out of this expression: `a * c + b * c`.
 - Reduce `1 * a` and `a * 1` to just `a`.
 - Reduce `0 * a` and `a * 0` to just `0`.
 - Reduce `0 + a` and `a + 0` to just `a`.
 - Are there any other simplification patterns you know of that you could implement?
 */
// TODO
/*:
 2.) Implement infix operators `*` and `+` to work on `Expr` to get rid of the `.add` and `.mul` annotations.
 */
// TODO
/*:
 3.) Implement a function `varCount: (Expr) -> Int` that counts the number of `.var`s used in an expression.
 */
// TODO
/*:
 4.) Write a pretty printer for `Expr` that adds a new line and indentation when printing the sub-expressions inside `.add` and `.mul`.
 */
// TODO
