extension Character: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        String(self)
    }
}

extension ObjectIdentifier: FargoDumpStringConvertible {
    public var fargoDumpDescription: String {
        self.debugDescription
    }
}

extension StaticString: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        "\(self)"
    }
}

extension UnicodeScalar: FargoDumpRepresentable {
    public var fargoDumpValue: Any {
        String(self)
    }
}
