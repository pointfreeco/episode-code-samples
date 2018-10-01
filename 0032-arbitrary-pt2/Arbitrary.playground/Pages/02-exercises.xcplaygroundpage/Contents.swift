/*:
 # Decodable Randomness: Part 2

 ## Exercises

 1.) Redefine `Gen`'s base unit of randomness, `random`, which is a `Gen<UInt32>` to work with Swift 4.2's base unit of randomness, the `RandomNumberGenerator` protocol. The base random type should should change to `UInt64`.
 */
// TODO
/*:
 2.) Swift 4.2's protocol-oriented solution allows us to define custom types that conform to `RandomNumberGenerator`. Update `Gen` to evaluate given any `RandomNumberGenerator` by changing `run`'s signature.
 */
// TODO
/*:
 3.) Use a custom random number generator that can be configured with a stable seed to allow for the `Gen` type to predictably generate the same random value for a given seed.

 You can look to [Nate Cook's playground](https://forums.swift.org/t/se-0202-random-unification/11313/30), shared on the Swift forums, or (for bonus points), you can define your own [linear congruential generator](https://en.wikipedia.org/wiki/Linear_congruential_generator) (or LCG).
 */
// TODO
/*:
 4.) Write a helper that runs a property test for `XCTest`! A property test, given a generator and a block of code, will evaluate the block of code with a configurable number of random runs. If the block returns `true`, the property test passes. It it returns `false`, it fails. The signature should be the following.

     func forAll<A>(_ a: Gen<A>, propertyShouldHold: (A) -> Bool)

 It should, internally, call an `XCTAssert` function. Upon failure, print out the seed so that it can be reproduced.
 */
// TODO
/*:
 5.) Enhance the `forAll` API to take the parameters `file: StaticString = #file` and `line: UInt = #line`, which can be passed to XCTest assertions in order to highlight the correct line on failure.
 */
// TODO
