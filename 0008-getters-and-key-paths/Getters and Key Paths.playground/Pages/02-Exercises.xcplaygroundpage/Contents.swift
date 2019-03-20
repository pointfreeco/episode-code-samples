/*:
 # Getters and Key Paths Exercises

 1. Find three more standard library APIs that can be used with our `get` and `^` helpers.
 */
// TODO
/*:
 2. The one downside to key paths being _only_ compiler generated is that we do not get to create new ones ourselves. We only get the ones the compiler gives us.

    And there are a lot of getters and setters that are not representable by key paths. For example, the “identity” key path `KeyPath<A, A>` that simply returns `self` for the getter and that setting on it leaves it unchanged. Can you think of any other interesting getters/setters that cannot be represented by key paths?
 */
// TODO
/*:
 3. In our [Setters and Key Paths](https://www.pointfree.co/episodes/ep7-setters-and-key-paths) episode we showed how `map` could kinda be seen as a “setter” by saying:

    “If you tell me how to transform an `A` into a `B`, I will tell you how to transform an `[A]` into a `[B]`.”

    There is also a way to think of `map` as a “getter” by saying:

    “If you tell me how to get a `B` out of an `A`, I will tell you how to get an `[B]` out of an `[A]`.”

    Try composing `get` with free `map` function to construct getters that go even deeper into a structure.

    You may want to use the data types we defined [last time](https://github.com/pointfreeco/episode-code-samples/blob/1998e897e1535a948324d590f2b53b6240662379/0007-setters-and-key-paths/Setters%20and%20Key%20Paths.playground/Contents.swift#L2-L20).
 */
// TODO
/*:
 4. Repeat the above exercise by seeing how the free optional `map` can allow you to dive deeper into an optional value to extract out a part.

    Key paths even give first class support for this operation. Do you know what it is?
 */
// TODO
/*:
 5. Key paths aid us in getter composition for structs, but enums don't have any stored properties. Write a getter function for `Result` that plucks out a value if it exists, such that it can compose with `get`. Use this function with a value in `Result<User, String>` to return the user's name.
 */
// TODO
/*:
 6. Key paths work immediately with all fields in a struct, but only work with computed properties on an enum. We saw in [Algebra Data Types](https://www.pointfree.co/episodes/ep4-algebraic-data-types) that structs and enums are really just two sides of a coin: neither one is more important or better than the other.

    What would it look like to define an `EnumKeyPath<Root, Value>` type that encapsulates the idea of “getting” and “setting” cases in an enum?
 */
// TODO
/*:
 7. Given a value in `EnumKeyPath<A, B>` and `EnumKeyPath<B, C>`, can you construct a value in
 `EnumKeyPath<A, C>`?
 */
// TODO
/*:
 8. Given a value in `EnumKeyPath<A, B>` and a value in `EnumKeyPath<A, C>`, can you construct a value in `EnumKeyPath<A, Either<B, C>>`?
 */
// TODO
