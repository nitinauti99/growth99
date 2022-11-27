
import Dispatch

public extension DispatchSource {
    typealias Add = DispatchSourceUserDataAdd
    typealias Or = DispatchSourceUserDataOr
    typealias MachSend = DispatchSourceMachSend
    typealias MachReceive = DispatchSourceMachReceive
    typealias MemoryPressure = DispatchSourceMemoryPressure
    typealias Process = DispatchSourceProcess
    typealias Read = DispatchSourceRead
    typealias Signal = DispatchSourceSignal
    typealias Timer = DispatchSourceTimer
}
