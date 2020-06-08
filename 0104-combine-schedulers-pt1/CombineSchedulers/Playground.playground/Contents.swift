import Combine
import Dispatch
import Foundation

var cancellables: Set<AnyCancellable> = []

//DispatchQueue.main.schedule {
//  print("DispatchQueue", "ASAP")
//}
//DispatchQueue.main.schedule(after: .init(.now() + 1)) {
//  print("DispatchQueue", "delayed")
//}
//DispatchQueue.main.schedule(after: .init(.now()), interval: 1) {
//  print("DispatchQueue", "timer")
//}.store(in: &cancellables)
//
//RunLoop.main.schedule {
//  print("RunLoop", "ASAP")
//}
//RunLoop.main.schedule(after: .init(Date() + 1)) {
//  print("RunLoop", "delayed")
//}
//RunLoop.main.schedule(after: .init(Date()), interval: 1) {
//  print("RunLoop", "timer")
//}.store(in: &cancellables)
//
//OperationQueue.main.schedule {
//  print("OperationQueue", "ASAP")
//}
//OperationQueue.main.schedule(after: .init(Date() + 1)) {
//  print("OperationQueue", "delayed")
//}
//OperationQueue.main.schedule(after: .init(Date()), interval: 1) {
//  print("OperationQueue", "timer")
//}.store(in: &cancellables)


//ImmediateScheduler.SchedulerTimeType

//ImmediateScheduler.shared.now.advanced(by: 1)
//
//ImmediateScheduler.shared.schedule {
//  print("ImmediateScheduler", "ASAP")
//}
//ImmediateScheduler.shared.schedule(after: ImmediateScheduler.shared.now.advanced(by: 1)) {
//  print("ImmediateScheduler", "delayed")
//}
//ImmediateScheduler.shared.schedule(after: ImmediateScheduler.shared.now, interval: 1) {
//  print("ImmediateScheduler", "timer")
//}.store(in: &cancellables)


Just(1)
.subscribe(on: <#T##Scheduler#>)
.receive(on: <#T##Scheduler#>)
.delay(for: <#T##SchedulerTimeIntervalConvertible & Comparable & SignedNumeric#>, scheduler: <#T##Scheduler#>)
.timeout(<#T##interval: SchedulerTimeIntervalConvertible & Comparable & SignedNumeric##SchedulerTimeIntervalConvertible & Comparable & SignedNumeric#>, scheduler: <#T##Scheduler#>)
.throttle(for: <#T##SchedulerTimeIntervalConvertible & Comparable & SignedNumeric#>, scheduler: <#T##Scheduler#>, latest: <#T##Bool#>)
.debounce(for: <#T##SchedulerTimeIntervalConvertible & Comparable & SignedNumeric#>, scheduler: <#T##Scheduler#>)

