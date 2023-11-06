# SyncUps: Stack-based navigation

This directory holds the SyncUps application built using “stack-based” navigation: that is, using 
`NavigationStack` with a binding to a collection. This allows you to represent all navigation paths 
in the application with a single, flat array of values. 

For example, to start the application in a state where the user is drilled down to the detail 
screen and _then_ drilled down to the record screen, you only need to construct an array with the 
models for each of those screens.

```swift
AppModel(
  path: [
    .detail(SyncUpDetailModel(syncUp: …)),
    .record(RecordMeetingModel(syncUp: …)),
  ]
)
```

Stack-based navigation can be very powerful:

* It allows you to decouple features from the places that can be navigated to. In the example above, 
it is possible to build the "detail feature" and the "record feature" in complete isolation with no 
dependence between the features.
* Stack-based navigation can easily handle complex navigation paths, such as many layers deep and 
even recursive paths. This is most useful for "wiki" style applications where you can drill down 
any number of layers to features (_e.g._, film database app, App Store, etc).
* Stack-based navigation APIs, in particular the initializer on `NavigationStack` that takes a 
binding, has fewer bugs than other state-based navigation APIs in SwiftUI.

However, they also have cons:

* Stack-based navigation is not concise. For example, our SyncUps app has a finite set of
navigation paths that make sense, and stack-based navigation allows for non-sensical paths. For
example, the  record screen can only ever happen after the detail screen, yet it's possible to
construct a path like this: `[.record, .detail]`.
* If you want to preview a screen in the stack or run it as an isolated app, it will be mostly 
inert. You will not be able to navigate to any other screens because that responsibility has been 
lifted to a parent feature.
* And related to the above two cons: stack-based navigation is more difficult to unit test. 

So, if you weigh the pros and cons of using stack-based navigation and still decide to use it, this 
SyncUps app shows how it can be done.
