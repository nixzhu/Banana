import Foundation
import yyjson

public protocol BananaModel {
    init(json: BananaJSON)
}

extension BananaModel {
    public static func decode(
        from data: Data,
        at path: [BananaPathItem] = [],
        allowingJSON5: Bool = false
    ) -> Self {
        let doc = data.withUnsafeBytes {
            yyjson_read(
                $0.bindMemory(to: CChar.self).baseAddress,
                data.count,
                allowingJSON5 ? YYJSON_READ_JSON5 : YYJSON_READ_NOFLAG
            )
        }

        if let doc {
            defer {
                yyjson_doc_free(doc)
            }

            var json = BananaJSON(
                pointer: yyjson_doc_get_root(doc)
            )

            for item in path {
                switch item {
                case .key(let key):
                    json = json[key]
                case .index(let index):
                    json = json[index]
                }
            }

            return .init(json: json)
        } else {
            return .init(json: .init(pointer: nil))
        }
    }

    public static func decode(
        from string: String,
        at path: [BananaPathItem] = [],
        allowingJSON5: Bool = false,
        using encoding: String.Encoding = .utf8
    ) -> Self {
        if let jsonData = string.data(using: encoding) {
            decode(from: jsonData, at: path, allowingJSON5: allowingJSON5)
        } else {
            .init(json: .init(pointer: nil))
        }
    }
}

extension Dictionary where Key == String, Value: BananaModel {
    public static func decode(
        from data: Data,
        at path: [BananaPathItem] = [],
        allowingJSON5: Bool = false
    ) -> Self {
        let doc = data.withUnsafeBytes {
            yyjson_read(
                $0.bindMemory(to: CChar.self).baseAddress,
                data.count,
                allowingJSON5 ? YYJSON_READ_JSON5 : YYJSON_READ_NOFLAG
            )
        }

        if let doc {
            defer {
                yyjson_doc_free(doc)
            }

            var json = BananaJSON(
                pointer: yyjson_doc_get_root(doc)
            )

            for item in path {
                switch item {
                case .key(let key):
                    json = json[key]
                case .index(let index):
                    json = json[index]
                }
            }

            return json.dictionary().mapValues { .init(json: $0) }
        } else {
            return [:]
        }
    }

    public static func decode(
        from string: String,
        at path: [BananaPathItem] = [],
        allowingJSON5: Bool = false,
        using encoding: String.Encoding = .utf8
    ) -> Self {
        if let jsonData = string.data(using: encoding) {
            decode(from: jsonData, at: path, allowingJSON5: allowingJSON5)
        } else {
            [:]
        }
    }
}

extension Array where Element: BananaModel {
    public static func decode(
        from data: Data,
        at path: [BananaPathItem] = [],
        allowingJSON5: Bool = false
    ) -> Self {
        let doc = data.withUnsafeBytes {
            yyjson_read(
                $0.bindMemory(to: CChar.self).baseAddress,
                data.count,
                allowingJSON5 ? YYJSON_READ_JSON5 : YYJSON_READ_NOFLAG
            )
        }

        if let doc {
            defer {
                yyjson_doc_free(doc)
            }

            var json = BananaJSON(
                pointer: yyjson_doc_get_root(doc)
            )

            for item in path {
                switch item {
                case .key(let key):
                    json = json[key]
                case .index(let index):
                    json = json[index]
                }
            }

            return json.array().map { .init(json: $0) }
        } else {
            return []
        }
    }

    public static func decode(
        from string: String,
        at path: [BananaPathItem] = [],
        allowingJSON5: Bool = false,
        using encoding: String.Encoding = .utf8
    ) -> Self {
        if let jsonData = string.data(using: encoding) {
            decode(from: jsonData, at: path, allowingJSON5: allowingJSON5)
        } else {
            []
        }
    }
}
