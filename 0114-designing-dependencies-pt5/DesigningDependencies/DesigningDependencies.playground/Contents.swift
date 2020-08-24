
import Network

let monitor = NWPathMonitor()
monitor.pathUpdateHandler = { path in
  print(path.status)
}
monitor.start(queue: .main)

