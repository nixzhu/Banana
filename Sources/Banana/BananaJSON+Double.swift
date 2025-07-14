import yyjson

extension BananaJSON {
    public enum DoubleMode {
        case normal
        case custom((BananaJSON) -> Double?)
    }

    public func double(_ mode: DoubleMode = .normal) -> Double? {
        switch mode {
        case .normal:
            if let double = rawDouble() {
                return double
            }
        case .custom(let parse):
            if let value = parse(self) {
                return value
            }
        }

        return nil
    }

    public func double(_ mode: DoubleMode = .normal, fallback: Double = 0) -> Double {
        double(mode) ?? fallback
    }
}
