## [Point-Free](https://www.pointfree.co)

> #### This directory contains code from Point-Free Episode: [Designing for Isolation: Naively](https://www.pointfree.co/episodes/ep381-designing-for-isolation-naively)
>
> We have a type that we want to be non-`Sendable`, but in order for it to participate in async code, it seems like we do need something `Sendable`. Let’s explore how we achieve this sendability in ComposableArchitecture 1.0, why it’s not ideal, and how a few new Swift concurrency tools allow us to get closer to our goal in a better way.
