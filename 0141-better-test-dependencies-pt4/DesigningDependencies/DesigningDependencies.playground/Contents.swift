//
//import Network
//
//let monitor = NWPathMonitor()
//monitor.pathUpdateHandler = { path in
//  print(path.status)
//}
//monitor.start(queue: .main)
//

import Combine

ImmediateScheduler.shared
  .schedule(after: ImmediateScheduler.shared.now.advanced(by: 100)) {
    print("hi")
  }
