/*:
 # The Many Faces of Flat-Map: Part 1

 ## Exercises

 1.) In this episode we saw that the `combos` function on arrays can be implemented in terms of `flatMap` and `map`. The `zip` function on arrays as the same signature as `combos`. Can `zip` be implemented in terms of `flatMap` and `map`?
 */
// TODO
/*:
 2.) Define a `flatMap` method on the `Result<A, E>` type. Its signature looks like:

 ```
 (Result<A, E>, (A) -> Result<B, E>) -> Result<B, E>
 ```

 It only changes the `A` generic while leaving the `E` fixed.
 */
// TODO
/*:
 3.) Can the `zip` function we defined on `Result<A, E>` in [episode #24](https://www.pointfree.co/episodes/ep24-the-many-faces-of-zip-part-2#t98) be implemented in terms of the `flatMap` you implemented above? If so do it, otherwise explain what goes wrong.
 */
// TODO
/*:
 4.) Define a `flatMap` method on the `Validated<A, E>` type. Its signature looks like:

 ```
 (Validated<A, E>, (A) -> Validated<B, E>) -> Validated<B, E>
 ```

 It only changes the `A` generic while leaving the `E` fixed. How similar is it to the `flatMap` you defined on `Result`?
 */
// TODO
/*:
 5.) Can the `zip` function we defined on `Validated<A, E>` in [episode #24](/episodes/ep24-the-many-faces-of-zip-part-2#t367) be defined in terms of the `flatMap` above? If so do it, otherwise explain what goes wrong.
 */
// TODO
/*:
 6.) Define a `flatMap` method on the `Func<A, B>` type. Its signature looks like:

 ```
 (Func<A, B>, (B) -> Func<A, C>) -> Func<A, C>
 ```

 It only changes the `B` generic while leaving the `A` fixed.
 */
// TODO
/*:
 7.) Can the `zip` function we defined on `Func<A, B>` in [episode #24](/episodes/ep24-the-many-faces-of-zip-part-2#t817) be implemented in terms of the `flatMap` you implemented above? If so do it, otherwise explain what goes wrong.
 */
// TODO
/*:
 8.) Define a `flatMap` method on the `Parallel<A>` type. Its signature looks like:

 ```
 (Parallel<A>, (A) -> Parallel<B>) -> Parallel<B>
 ```
 */
// TODO
/*:
 9.) Can the `zip` function we defined on `Parallel<A>` in [episode #24](https://www.pointfree.co/episodes/ep24-the-many-faces-of-zip-part-2#t1252) be implemented in terms of the `flatMap` you implemented above? If so do it, otherwise explain what goes wrong.
 */
// TODO
