import yyjson

extension BananaJSON {
    public enum StringMode {
        case normal
        case custom((BananaJSON) -> String?)
    }

    public func string(_ mode: StringMode = .normal) -> String? {
        switch mode {
        case .normal:
            if let string = rawString() {
                return string
            }
        case .custom(let parse):
            if let value = parse(self) {
                return value
            }
        }

        return nil
    }

    public func string(_ mode: StringMode = .normal, fallback: String = "") -> String {
        string(mode) ?? fallback
    }
}
