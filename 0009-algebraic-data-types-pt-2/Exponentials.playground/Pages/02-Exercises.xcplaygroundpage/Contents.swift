/*:
 # Algebraic Data Types: Exponents, Exercises

 1. Explore the equivalence of `1^a = a`.
 */
// TODO
/*:
 2. Explore the properties of `0^a`. Consider the cases where `a = 0` and `a != 0` separately.
 */
// TODO
/*:
 3. How do you think generics fit into algebraic data types? We've seen a bit of this with thinking of `Optional<A>` as `A + 1 = A + Void`.
 */
// TODO
/*:
 4. Show that the set type over a type `A` can be represented as `2^A`. What does union and intersection look like in this formulation?
 */
// TODO
/*:
 5. Show that the dictionary type with keys in `K`  and values in `V` can be represented by `V^K`. What does union of dictionaries look like in this formulation?
 */
// TODO
/*:
 6. Implement the following equivalence:
 */
func to<A, B, C>(_ f: @escaping (Either<B, C>) -> A) -> ((B) -> A, (C) -> A) {
  fatalError()
}

func from<A, B, C>(_ f: ((B) -> A, (C) -> A)) -> (Either<B, C>) -> A {
  fatalError()
}
/*:
 7. Implement the following equivalence:
 */
func to<A, B, C>(_ f: @escaping (C) -> (A, B)) -> ((C) -> A, (C) -> B) {
  fatalError()
}

func from<A, B, C>(_ f: ((C) -> A, (C) -> B)) -> (C) -> (A, B) {
  fatalError()
}
