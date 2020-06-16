## [Point-Free](https://www.pointfree.co)

> #### This directory contains code from Point-Free Episode: [Combine Schedulers: Erasing Time](https://www.pointfree.co/episodes/ep106-combine-schedulers-erasing-time)
>
> We refactor our application’s code so that we can run it in production with a live dispatch queue for the scheduler, while allowing us to run it in tests with a test scheduler. If we do this naively we will find that generics infect many parts of our code, but luckily we can employ the technique of type erasure to make things much nicer.
