/*:
 # DSLs vs. Templating Languages

 ## Exercises

 1.) Create a function called `frequency` that takes an array of pairs, `[(Int, Gen<A>)]`, to create a `Gen<A>` such that `(2, gen)` is twice as likely to be run than a `(1, gen)`.
 */
// TODO
/*:
 2.) Extend `Gen` with an `optional` computed property that returns a generator that returns `nil` a quarter of the time. What other generators can you compose this from?
 */
// TODO
/*:
 3.) Extend `Gen` with a `filter` method that returns a generator that filters out random entries that don't match the predicate. What kinds of problems may this function have?
 */
// TODO
/*:
 4.) Create a `string` generator of type `Gen<String>` that randomly produces a randomly-sized string of any unicode character. What smaller generators do you composed it from?
 */
// TODO
/*:
 5.) Redefine `element(of:)` to work with any `Collection`. Can it also be redefined in terms of `Sequence`?
 */
// TODO
/*:
 6.) Create a `subsequence` generator to return a randomly-sized, randomly-offset subsequence of an array. Can it be redefined in terms of `Collection`?
 */
// TODO
/*:
 7.) The `Gen` type has `map` defined it, which, as we've seen in the past, allows us to consider what `zip` might look like. Define `zip2` on `Gen`:

     func zip2<A, B>(_ ga: Gen<A>, _ gb: Gen<B>) -> Gen<(A, B)>
 */
// TODO
/*:
 8.) Define `zip2(with:)`:

     func zip2<A, B, C>(with f: (A, B) -> C) -> (Gen<A>, Gen<B>) -> Gen<C>
 */
// TODO
/*:
 9.) With `zip2` and `zip2(with:)` defined, define higher-order `zip3` and `zip3(with:)` and explore some uses. What functionality does `zip` provide our `Gen` type?
 */
// TODO
