
import Foundation
import Network

/// Enum to provide status whether the network is reachable or not.
public enum ReachabilityStatus {

    /// Network is reachable
    case reachable

    /// Network is unreachable
    case notReachable
}

/// A class type to monitor any changes in network reachability
public class NetworkMonitor {

    /// Typealias for listener block
    public typealias Listener = (ReachabilityStatus) -> Void

    /// Listener block to listen for any change in network reachability
    public var listener: Listener?

    /// Helper boolean to check if the network is reachable
    public private(set) var isReachable = false

    /// Helper boolean to check if the monitor is enabled
    public private(set) var isEnabled = false

    /// Instance of NWPathMonitor to be used for network monitoring
    private var monitor = NWPathMonitor()

    /// Serial queue where network monitoring will happen
    private let monitorQueue = DispatchQueue(label: "com.apple.ist.GrowthNetwork.monitorQueue")

    public init() {}

    deinit {
        self.listener = nil
        self.monitor.cancel()
    }

    /**
        API to start network monitoring
     */
    public func start() {
        self.isEnabled = true
        self.monitor.start(queue: self.monitorQueue)

        self.monitor.pathUpdateHandler = { path in
            self.isReachable = path.status == .satisfied
            switch path.status {
            case .satisfied:
                self.listener?(.reachable)
            default:
                self.listener?(.notReachable)
            }
        }
    }

    /**
       API to stop network monitoring
    */
    public func stop() {
        self.isEnabled = false
        self.monitor.cancel()
        self.isReachable = false
        // Once you cancel a path monitor, that specific object is done. You can’t start it again with the same instance.
        self.monitor = NWPathMonitor()
    }

    /// Helper get method to return current network interface settting
    public var currentPath: NWPath {
        self.monitor.currentPath
    }

}
