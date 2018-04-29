/*:
 # Contravariance Exercises

 1.) Determine the sign of all the type parameters in the function `(A) -> (B) -> C`. Note that this is a curried function. It may be helpful to fully parenthesize the expression before determining variance.
 */
// TODO
/*:
 2.) Determine the sign of all the type parameters in the following function:

 `(A, B) -> (((C) -> (D) -> E) -> F) -> G`
 */
// TODO
/*:
 3.) Recall that [a setter is just a function](https://www.pointfree.co/episodes/ep6-functional-setters#t813) `((A) -> B) -> (S) -> T`. Determine the variance of each type parameter, and define a `map` and `contramap` for each one. Further, for each `map` and `contramap` write a description of what those operations mean intuitively in terms of setters.
 */
// TODO
/*:
 4.) Define `union`, `intersect`, and `invert` on `PredicateSet`.
 */
// TODO
/*:
 This collection of exercises explores building up complex predicate sets and understanding their performance characteristics.

 5a.) Create a predicate set `isPowerOf2: PredicateSet<Int>` that determines if a value is a power of `2`, _i.e._ `2^n` for some `n: Int`.
 */
// TODO
/*:
 5b.) Use the above predicate set to derive a new one `isPowerOf2Minus1: PredicateSet<Int>` that tests if a number is of the form `2^n - 1` for `n: Int`.
 */
// TODO
/*:
 5c.) Find an algorithm online for testing if an integer is prime, and turn it into a predicate `isPrime: PredicateSet<Int>`.
 */
// TODO
/*:
 5d.) The intersection `isPrime.intersect(isPowerOf2Minus1)` consists of numbers known as [Mersenne primes](https://en.wikipedia.org/wiki/Mersenne_prime). Compute the first 10.
 */
// TODO
/*:
 5e.) Recall that `&&` and `||` are short-circuiting in Swift. How does that translate to `union` and `intersect`?
 */
// TODO
/*:
 6.) What is the difference between `isPrime.intersect(isPowerOf2Minus1)` and `isPowerOf2Minus1.intersect(isPrime)`? Which one represents a more performant predicate set?
 */
// TODO
/*:
 7.) It turns out that dictionaries `[K: V]` do not have `map` on `K` for all the same reasons `Set` does not. There is an alternative way to define dictionaries in terms of functions. Do that and define `map` and `contramap` on that new structure.
 */
// TODO
/*:
 8.) Define `CharacterSet` as a type alias of `PredicateSet`, and construct some of the sets that are currently available in the [API](https://developer.apple.com/documentation/foundation/characterset#2850991).
 */
// TODO
/*:
 Let's explore happens when a type parameter appears multiple times in a function signature.

 9a.) Is `A` in positive or negative position in the function `(B) -> (A, A)`? Define either `map` or `contramap` on `A`.
 */
// TODO
/*:
 9b.) Is `A` in positive or negative position in `(A, A) -> B`? Define either `map` or `contramap`.
 */
// TODO
/*:
 9c.) Consider the type `struct Endo<A> { let apply: (A) -> A }`. This type is called `Endo` because functions whose input type is the same as the output type are called "endomorphisms". Notice that `A` is in both positive and negative position. Does that mean that _both_ `map` and `contramap` can be defined, or that neither can be defined?
 */
// TODO
/*:
 9d.) Turns out, `Endo` has a different structure on it known as an "invariant structure", and it comes equipped with a different kind of function called `imap`. Can you figure out what it’s signature should be?
 */
// TODO
/*:
 10.) Consider the type `struct Equate<A> { let equals: (A, A) -> Bool }`. This is just a struct wrapper around an equality check. You can think of it as a kind of "type erased" `Equatable` protocol. Write `contramap` for this type.
 */
// TODO
/*:
 11.) Consider the value `intEquate = Equate<Int> { $0 == $1 }`. Continuing the "type erased" analogy, this is like a "witness" to the `Equatable` conformance of `Int`. Show how to use `contramap` defined above to transform `intEquate` into something that defines equality of strings based on their character count.
 */
// TODO
