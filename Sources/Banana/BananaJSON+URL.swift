import Foundation

extension BananaJSON {
    public enum URLMode {
        case normal
        case custom((BananaJSON) -> URL?)
    }

    public func url(_ mode: URLMode = .normal) -> URL? {
        switch mode {
        case .normal:
            if let string = rawString() {
                if let url = URL(string: string) {
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

    public func url(_ mode: URLMode = .normal, fallback: URL = .init(string: "/")!) -> URL {
        url(mode) ?? fallback
    }
}
