/*:
 # Functional Setters Exercises

 1. As we saw with free `map` on `Array`, define free `map` on `Optional` and use it to compose setters that traverse into an optional field.
 */
// TODO
/*:
 2. Take the following `User` struct and write a setter for its `name` property. Add another property, and add a setter for it. What are some potential issues with building these setters?
 */
struct User {
  let name: String
}
// TODO
/*:
 3. Add a `location` property to `User`, which holds a `Location`, defined below. Write a setter for `userLocationName`. Now write setters for `userLocation` and `locationName`. How do these setters compose?
 */
struct Location {
  let name: String
}
// TODO
/*:
 4. Do `first` and `second` work with tuples of three or more values? Can we write `first`, `second`, `third`, and `nth` for tuples of _n_ values?
 */
// TODO
/*:
 5. Write a setter for a dictionary that traverses into a key to set a value.
 */
// TODO
/*:
 6. What is the difference between a function of the form `((A) -> B) -> (C) -> (D)` and one of the form `(A) -> (B) -> (C) -> D`?
 */
// TODO
