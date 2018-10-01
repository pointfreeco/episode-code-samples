/*:
 # Decodable Randomness: Part 1

 ## Exercises

 1.) We skipped over the `allKeys` property of the `KeyedDecodingContainerProtocol`, but it's what's necessary to decode dictionaries of values. On initialization of the `KeyedDecodingContainer`, generate a random number of random `CodingKey`s to populate this property.

 You'll need to return `true` from `contains(_ key: Key)`.

 Decode a few random dictionaries of various decodable keys and values. What are some of the limitations of decoding dictionaries?
 */
// TODO
/*:
 2.) Create a new `UnkeyedContainer` struct that conforms to the `UnkeyedContainerProtocol` and return it from the `unkeyedContainer()` method of `ArbitraryDecoder`. As with the `KeyedDecodingContainer`, you can delete the same `decode` methods and have them delegate to the `SingleValueContainer`.

 The `count` property can be used to generate a randomly-sized container, while `currentIndex` and `isAtEnd` can be used to let the decoder know how far along it is. Generate a random `count`, default the `currentIndex` to `0`, and define `isAtEnd` as a computed property using these values. The `currentIndex` property should increment whenever `superDecoder` is called.

 Decode a few random arrays of various decodable elements.
 */
// TODO
