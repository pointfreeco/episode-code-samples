/*:
 # The Many Faces of Zip: Part 2

 ## Exercises

 1.) Can you make the `zip2` function on our `F3` type thread safe?
 */
// TODO
/*:
 2.) Generalize the `F3` type to a type that allows returning values other than `Void`: `struct F4<A, R> { let run: (@escaping (A) -> R) -> R }`. Define `zip2` and `zip2(with:)` on the `A` type parameter.
 */
// TODO
/*:
 3.) Find a function in the Swift standard library that resembles the function above. How could you use `zip2` on it?
 */
// TODO
/*:
 4.) This exercise explore what happens when you nest two types that each support a `zip` operation.

 - Consider the type `[A]? = Optional<Array<A>>`. The outer layer `Optional`  has `zip2` defined, but also the inner layer `Array`  has a `zip2`. Can we define a `zip2` on `[A]?` that makes use of both of these zip structures? Write the signature of such a function and implement it.
 */
// TODO
/*:
 - Using the `zip2` defined above write an example usage of it involving two `[A]?` values.
 */
// TODO
/*:
 - Consider the type `[Validated<A, E>]`. We again have have a nesting of types, each of which have their own `zip2` operation. Can you define a `zip2` on this type that makes use of both `zip` structures? Write the signature of such a function and implement it.
 */
// TODO
/*:
 - Using the `zip2` defined above write an example usage of it involving two `[Validated<A, E>]` values.
 */
// TODO
/*:
 - Consider the type `Func<R, A?>`. Again we have a nesting of types, each of which have their own `zip2` operation. Can you define a `zip2` on this type that makes use of both structures? Write the signature of such a function and implement it.
 */
// TODO
/*:
 - Consider the type `Func<R, [A]>`. Again we have a nesting of types, each of which have their own `zip2` operation. Can you define a `zip2` on this type that makes use of both structures? Write the signature of such a function and implement it.
 */
// TODO
/*:
 - Do you see anything common in the implementation of all of your functions?
 */
// TODO
/*:
 5.) In this series of episodes on `zip` we have described zipping types as a kind of way to swap the order of containers, e.g. we can transform a tuple of arrays to an array of tuples `([A], [B]) -> [(A, B)]`. There’s a more general concept that aims to flip contains of any type. Implement the following to the best of your ability, and describe in words what they represent:

 - `sequence: ([A?]) -> [A]?`
 - `sequence: ([Result<A, E>]) -> Result<[A], E>`
 - `sequence: ([Validated<A, E>]) -> Validated<[A], E>`
 - `sequence: ([F3<A>]) -> F3<[A]`
 - `sequence: (Result<A?, E>) -> Result<A, E>?`
 - `sequence: (Validated<A?, E>) -> Validated<A, E>?`
 - `sequence: ([[A]]) -> [[A]]`.

 Note that you can still flip the order of these containers even though they are both the same container type. What does this represent? Evaluate the function on a few sample nested arrays.

 Note that all of these functions also represent the flipping of containers, e.g. an array of optionals transforms into an optional array, an array of results transforms into a result of an array, or a validated optional transforms into an optional validation, etc.
 */
// TODO
