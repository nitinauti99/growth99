//
//  FargoDumpReflectable.swift
//  FargoCore-iOS
//
//  Created by Kushal Jogi on 9/27/21.
//

public protocol FargoDumpReflectable {
    /// The customized dump mirror for this instance.
    var fargoDumpMirror: Mirror { get }
}

extension Mirror {
    init(fargoDumpReflecting subject: Any) {
        self = (subject as? FargoDumpReflectable)?.fargoDumpMirror ?? Mirror(reflecting: subject)
    }
}
