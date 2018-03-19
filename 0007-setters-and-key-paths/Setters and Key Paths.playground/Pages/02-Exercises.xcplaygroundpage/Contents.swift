/*:
 # Setters and Key Paths Exercises

 1. In this episode we used `Dictionary`’s subscript key path without explaining it much. For a `key: Key`, one can construct a key path `\.[key]` for setting a value associated with `key`. What is the signature of the setter `prop(\.[key])`? Explain the difference between this setter and the setter `prop(\.[key]) <<< map`, where `map` is the optional map.
 */
// TODO
/*:
 2. The `Set<A>` type in Swift does not have any key paths that we can use for adding and removing values. However, that shouldn't stop us from defining a functional setter! Define a function `elem` with signature `(A) -> ((Bool) -> Bool) -> (Set<A>) -> Set<A>`, which is a functional setter that allows one to add and remove a value `a: A` to a set by providing a transformation `(Bool) -> Bool`, where the input determines if the value is already in the set and the output determines if the value should be included.
 */
// TODO
/*:
 3. Generalizing exercise #1 a bit, it turns out that all subscript methods on a type get a compiler generated key path. Use array’s subscript key path to uppercase the first favorite food for a user. What happens if the user’s favorite food array is empty?
 */
// TODO
/*:
 4. Recall from a [previous episode](https://www.pointfree.co/episodes/ep5-higher-order-functions) that the free `filter` function on arrays has the signature `((A) -> Bool) -> ([A]) -> [A]`. That’s kinda setter-like! What does the composed setter `prop(\\User.favoriteFoods) <<< filter` represent?
 */
// TODO
/*:
 5. Define the `Result<Value, Error>` type, and create `value` and `error` setters for safely traversing into those cases.
 */
// TODO
/*:
 6. Is it possible to make key path setters work with `enum`s?
 */
// TODO
/*:
 7. Redefine some of our setters in terms of `inout`. How does the type signature and composition change?
 */
// TODO
