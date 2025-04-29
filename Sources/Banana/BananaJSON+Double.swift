import yyjson

extension BananaJSON {
    public enum DoubleMode {
        case strict
        case string
        case compatible
        case custom((BananaJSON) -> Double?)
    }

    public func doubleIfPresent(_ mode: DoubleMode = .strict) -> Double? {
        switch mode {
        case .strict:
            if let double = rawDouble() {
                return double
            }
        case .string:
            if let string = rawString(), let double = Double(string) {
                return double
            }
        case .compatible:
            if let double = rawDouble() {
                return double
            }

            if let string = rawString(), let double = Double(string) {
                return double
            }
        case .custom(let parse):
            if let value = parse(self) {
                return value
            }
        }

        return nil
    }

    public func double(_ mode: DoubleMode = .strict, fallback: Double = 0) -> Double {
        doubleIfPresent(mode) ?? fallback
    }
}
