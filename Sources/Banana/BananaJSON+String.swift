import yyjson

extension BananaJSON {
    public enum StringMode {
        case strict
        case int
        case compatible

        case custom((BananaJSON) -> String?)
    }

    public func stringIfPresent(_ mode: StringMode = .strict) -> String? {
        switch mode {
        case .strict:
            if let string = rawString() {
                return string
            }
        case .int:
            if let int = rawInt() {
                return .init(int)
            }
        case .compatible:
            if let string = rawString() {
                return string
            }

            if let int = rawInt() {
                return .init(int)
            }
        case .custom(let parse):
            if let value = parse(self) {
                return value
            }
        }

        return nil
    }

    public func string(_ mode: StringMode = .strict, fallback: String = "") -> String {
        stringIfPresent(mode) ?? fallback
    }
}
