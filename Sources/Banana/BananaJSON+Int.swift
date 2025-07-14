import yyjson

extension BananaJSON {
    public enum IntMode {
        case normal
        case custom((BananaJSON) -> Int?)
    }

    public func int(_ mode: IntMode = .normal) -> Int? {
        switch mode {
        case .normal:
            if let int = rawInt() {
                return int
            }
        case .custom(let parse):
            if let value = parse(self) {
                return value
            }
        }

        return nil
    }

    public func int(_ mode: IntMode = .normal, fallback: Int = 0) -> Int {
        int(mode) ?? fallback
    }
}
