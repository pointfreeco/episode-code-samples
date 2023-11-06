# SyncUps: Tree-based navigation

This directory holds the SyncUps application built using “tree-based” navigation, that is where 
feature describes an enum of all possible destinations one can navigate to from that feature.

For example, to start the application in a state where the user is drilled down to the detail screen 
and _then_ drilled down to the record screen, you can construct a piece of deeply nested enum state
that describes exactly where you want to navigate to:

```swift
SyncUpsListModel(
  destination: .detail(
    SyncUpDetailModel(
      destination: .record(
        RecordMeetingModel(syncUp: …)
      ),
      syncUp: …
    )
  )
)
```

SwiftUI takes care of the rest.

Tree-based navigation can be very powerful:

* It is a very concise data modeling tool. Each feature gets to precisely describe all the places
that can be navigated to, and so non-sensical navigation paths are forbidden by the compiler.
* Screens in the stack can be run in isolation as previews or standalone apps, and you can actually
navigate to other screens since everything is integrated together.
* Tree-based navigation features can be very easy to test since everything is integrated together.

However, they do also come with some cons:

* It couples the source feature with the destination feature. If feature A needs to be able to 
navigate to features B, C, D, then in order to work on A you must compile all of B, C and D. And
further, also compile any destinations B, C and D might navigate to.
* Tree-based navigation does not easily allow for recursive or complex navigation paths, such as
is common with "wiki" style applications where you can drill down any number of layers into features
(e.g. film database app, App Store, etc).
* Tree-based navigation APIs, such as `navigationDestination(isPresented:)`, are _still_ riddled 
with bugs that make them nearly unusable. We have filed many bugs with Apple (see [here][nav-bugs]),
and we high recommend that if you like tree-based navigation that you duplicate those bugs.

So, if you weigh the pros and cons of using tree-based navigation and still decide to use it, this 
SyncUps up shows how it can be done.

[nav-bugs]: https://gist.github.com/mbrandonw/f8b94957031160336cac6898a919cbb7