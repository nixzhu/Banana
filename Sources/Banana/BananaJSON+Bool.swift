import yyjson

extension BananaJSON {
    public enum BoolMode {
        case strict
        case int
        case compatible
        case custom((BananaJSON) -> Bool?)
    }

    public func boolIfPresent(_ mode: BoolMode = .strict) -> Bool? {
        switch mode {
        case .strict:
            if let bool = rawBool() {
                return bool
            }
        case .int:
            if let int = rawInt() {
                switch int {
                case 0:
                    return false
                case 1:
                    return true
                default:
                    break
                }
            }
        case .compatible:
            if let bool = rawBool() {
                return bool
            }

            if let int = rawInt() {
                switch int {
                case 0:
                    return false
                case 1:
                    return true
                default:
                    break
                }
            }
        case .custom(let parse):
            if let value = parse(self) {
                return value
            }
        }

        return nil
    }

    public func bool(_ mode: BoolMode = .strict, fallback: Bool = false) -> Bool {
        boolIfPresent(mode) ?? fallback
    }
}
