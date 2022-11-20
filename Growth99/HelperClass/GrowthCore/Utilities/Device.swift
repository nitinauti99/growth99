//
//  Device.swift
//  Fargo
//
//  Created by Robin van Dijke on 4/4/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#if os(iOS)
import SystemConfiguration.CaptiveNetwork
import UIKit
#elseif os(OSX)
import CoreWLAN
#endif

public struct Device {
    public static var current: Device {
        Device()
    }

    public var name: String {
        var currentName: String?
        #if os(iOS)
        currentName = UIDevice.current.name
        #elseif os(OSX)
        currentName = Host.current().localizedName
        #endif

        return currentName ?? ""
    }

    public var systemVersion: String {
        #if os(iOS)
        return UIDevice.current.systemVersion
        #elseif os(macOS)
        let osEnum = ProcessInfo.processInfo.operatingSystemVersion
        return "\(osEnum.majorVersion).\(osEnum.minorVersion).\(osEnum.patchVersion)"
        #endif
    }

    public var wifiSSID: String {
        var currentSSID = ""
        #if os(iOS)
        if let interfaces = CNCopySupportedInterfaces() as? [String] {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as CFString) as? [String: Any],
                    let ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String {
                    currentSSID = ssid
                    break
                }
            }
        }
        #elseif os(OSX)
        if let anInterface = CWWiFiClient.shared().interface(), let ssid = anInterface.ssid() {
            currentSSID = ssid
        }
        #endif
        return currentSSID
    }

    public static let isAttachedToDebugger: Bool = {
        var info = kinfo_proc()
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout<kinfo_proc>.stride
        let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)

        assert(junk == 0, "sysctl failed")
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }()
}
