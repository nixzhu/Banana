import Foundation

extension BananaJSON {
    public enum URLMode {
        case compatible
        case custom((BananaJSON) -> URL?)
    }

    public func url(_ mode: URLMode = .compatible) -> URL? {
        switch mode {
        case .compatible:
            if let string = rawString() {
                if let url = URL(string: string) {
                    return url
                }

                if let encoded = string.addingPercentEncoding(withAllowedCharacters: .ananda_url),
                   let url = URL(string: encoded)
                {
                    return url
                }
            }
        case .custom(let parse):
            if let value = parse(self) {
                return value
            }
        }

        return nil
    }

    public func url(_ mode: URLMode = .compatible, fallback: URL = .init(string: "/")!) -> URL {
        url(mode) ?? fallback
    }
}

extension CharacterSet: @retroactive @unchecked Sendable {
    fileprivate static let ananda_url: Self = {
        var set = CharacterSet.urlQueryAllowed
        set.insert("#")
        set.formUnion(.urlPathAllowed)

        return set
    }()
}
