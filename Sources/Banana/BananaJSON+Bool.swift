import yyjson

extension BananaJSON {
    public enum BoolMode {
        case normal
        case custom((BananaJSON) -> Bool?)
    }

    public func bool(_ mode: BoolMode = .normal) -> Bool? {
        switch mode {
        case .normal:
            if let bool = rawBool() {
                return bool
            }
        case .custom(let parse):
            if let value = parse(self) {
                return value
            }
        }

        return nil
    }

    public func bool(_ mode: BoolMode = .normal, fallback: Bool = false) -> Bool {
        bool(mode) ?? fallback
    }
}
