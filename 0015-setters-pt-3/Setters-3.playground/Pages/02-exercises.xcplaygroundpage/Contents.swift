/*:
 # Setters: Ergonomics & Performance Exercises

 1.) We previously saw that functions `(inout A) -> Void` and functions `(A) -> Void where A: AnyObject` can be composed the same way. Write `mver`, `mut`, and `^` in terms of `AnyObject`. Note that there is a specific subclass of `WritableKeyPath` for reference semantics.
 */
// TODO
/*:
 2.) Our [episode on UIKit styling](/episodes/ep3-uikit-styling-with-functions) was nothing more than setters in disguise! Explore building some of the styling functions we covered using both immutable and mutable setters, specifically how setters compose over sub-typing in Swift, and how setters compose between roots that are reference types, and values that are value types.
 */
// TODO
/*:
 3.) We've explored `<>`/`concat` as single-type composition, but this doesn't mean we're limited to a single generic parameter! Write a version of `<>`/`concat` that allows for composition of value transformations of the same input and output type. This should allow for `prop(\\UIEdgeInsets.top) <> prop(\\.bottom)` as a way of assigning both `top` and `bottom` the same value at once.
 */
// TODO
/*:
 4.) Define an operator-free version of setters using `with` and `concat` from our episode on [composition without operators](/episodes/ep11-composition-without-operators). Define an `update` function that combines the semantics of `with` and the variadic convenience of `concat` for ergonomics.
 */
// TODO
/*:
 5.) In the Haskell Lens library, `over` and `set` are defined as infix operators `%~` and `.~`. Define these operators and explore what their precedence should be, updating some of our examples to use them. Do these operators tick the boxes?
 */
// TODO
