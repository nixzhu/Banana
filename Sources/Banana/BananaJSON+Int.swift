import yyjson

extension BananaJSON {
    public enum IntMode {
        case strict
        case string
        case compatible
        case custom((BananaJSON) -> Int?)
    }

    public func int(_ mode: IntMode = .strict) -> Int? {
        switch mode {
        case .strict:
            if let int = rawInt() {
                return int
            }
        case .string:
            if let string = rawString(), let int = Int(string) {
                return int
            }
        case .compatible:
            if let int = rawInt() {
                return int
            }

            if let string = rawString(), let int = Int(string) {
                return int
            }
        case .custom(let parse):
            if let value = parse(self) {
                return value
            }
        }

        return nil
    }

    public func int(_ mode: IntMode = .strict, fallback: Int = 0) -> Int {
        int(mode) ?? fallback
    }
}
