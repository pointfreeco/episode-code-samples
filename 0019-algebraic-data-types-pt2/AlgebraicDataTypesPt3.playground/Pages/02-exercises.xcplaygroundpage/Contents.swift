/*:
 # Algebraic Data Types: Generics and Recursion

 1.) Define addition and multiplication on `NaturalNumber`:

 * `func +(_ lhs: NaturalNumber, _ rhs: NaturalNumber) -> NaturalNumber`
 * `func *(_ lhs: NaturalNumber, _ rhs: NaturalNumber) -> NaturalNumber`

 */
// TODO
/*:
 2.) Implement the `exp` function on `NaturalNumber` that takes a number to a power:

 `exp(_ base: NaturalNumber, _ power: NaturalNumber) -> NaturalNumber`
 */
// TODO
/*:
 3.) Conform `NaturalNumber` to the `Comparable` protocol.
 */
// TODO
/*:
 4.) Implement `min` and `max` functions for `NaturalNumber`.
 */
// TODO
/*:
 5.) How could you implement *all* integers (both positive and negative) as an algebraic data type? Define all of the above functions and conformances on that type.
 */
// TODO
/*:
 6.) What familiar type is `List<Void>` equivalent to? Write `to` and `from` functions between those types showing how to travel back-and-forth between them.
 */
// TODO
/*:
 7.) Conform `List` and `NonEmptyList` to the `ExpressibleByArrayLiteral` protocol.
 */
// TODO
/*:
 8.) Conform `List` to the `Collection` protocol.
 */
// TODO
/*:
 9.) Conform each implementation of `NonEmptyList` to the `Collection` protocol.
 */
// TODO
/*:
 10.) Consider the type `enum List<A, B> { cae empty; case cons(A, B) }`. It's kinda like list without recursion, where the recursive part has just been replaced with another generic. Now consider the strange type:

    enum Fix<A> {
      case fix(ListF<A, Fix<A>>)
    }

 Construct a few values of this type. What other type does `Fix` seem to resemble?
 */
// TODO
/*:
 11.) Construct an explicit mapping between the `List<A>` and `Fix<A>` types by implementing:

 * `func to<A>(_ list: List<A>) -> Fix<A>`
 * `func from<A>(_ fix: Fix<A>) -> List<A>`

 The type `Fix` is known as the "fixed-point" of `List`. It is more generic than just dealing with lists, but unfortunately Swift does not have the type feature (higher-kinded types) to allow us to express this.
 */
// TODO
