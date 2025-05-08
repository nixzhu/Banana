public enum BananaPathItem: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral {
    case key(String)
    case index(Int)

    public init(stringLiteral value: String) {
        self = .key(value)
    }

    public init(integerLiteral value: Int) {
        self = .index(value)
    }
}
