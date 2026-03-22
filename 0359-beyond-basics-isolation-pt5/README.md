## [Point-Free](https://www.pointfree.co)

> #### This directory contains code from Point-Free Episode: [Isolation: OSUnfairAllocatedLock](https://www.pointfree.co/episodes/ep359-isolation-osunfairallocatedlock)
>
> It turns out that isolating state with an `NSLock` is not as straightforward as it seems, and we _still_ have a subtle data race. But Apple actually provides a more modern tool that _does_ help prevent this data race at compile time. Let's take it for a spin and get an understanding of how it works.
