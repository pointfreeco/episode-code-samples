/*:
 # The Many Faces of Zip: Part 3

 ## Exercises

 1.) In this series of episodes on `zip` we have described zipping types as a kind of way to swap the order of nested containers when one of those containers is a tuple, e.g. we can transform a tuple of arrays to an array of tuples `([A], [B]) -> [(A, B)]`. There's a more general concept that aims to flip containers of any type. Implement the following to the best of your ability, and describe in words what they represent:

 - `sequence: ([A?]) -> [A]?`
 - `sequence: ([Result<A, E>]) -> Result<[A], E>`
 - `sequence: ([Validated<A, E>]) -> Validated<[A], E>`
 - `sequence: ([Parallel<A>]) -> Parallel<[A]>`
 - `sequence: (Result<A?, E>) -> Result<A, E>?`
 - `sequence: (Validated<A?, E>) -> Validated<A, E>?`
 - `sequence: ([[A]]) -> [[A]]`. Note that you can still flip the order of these containers even though they are both the same container type. What does this represent? Evaluate the function on a few sample nested arrays.

 Note that all of these functions also represent the flipping of containers, e.g. an array of optionals transforms into an optional array, an array of results transforms into a result of an array, or a validated optional transforms into an optional validation, etc.

 Do the implementations of these functions have anything in common, or do they seem mostly distinct from each other?
 */
// TODO
/*:
 2.) There is a function closely related to `zip` called `apply`. It has the following shape: `apply: (F<(A) -> B>, F<A>) -> F<B>`. Define `apply` for `Array`, `Optional`, `Result`, `Validated`, `Func` and `Parallel`.
 */
// TODO
/*:
 3.) Another closely related function to `zip` is called `alt`, and it has the following shape: `alt: (F<A>, F<A>) -> F<A>`. Define `alt` for `Array`, `Optional`, `Result`, `Validated` and `Parallel`. Describe what this function semantically means for each of the types.
 */
// TODO
