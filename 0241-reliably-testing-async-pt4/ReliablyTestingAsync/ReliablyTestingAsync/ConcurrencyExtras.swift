import Darwin

typealias Original = @convention(thin) (UnownedJob) -> Void
typealias Hook = @convention(thin) (UnownedJob, Original) -> Void

var swift_task_enqueueGlobal_hook: Hook? {
  get { _swift_task_enqueueGlobal_hook.pointee }
  set { _swift_task_enqueueGlobal_hook.pointee = newValue }
}

private let _swift_task_enqueueGlobal_hook =
  dlsym(dlopen(nil, RTLD_LAZY), "swift_task_enqueueGlobal_hook")
    .assumingMemoryBound(to: Hook?.self)
