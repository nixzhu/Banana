import Foundation
import yyjson

public protocol BananaModel {
    init(json: BananaJSON)
}

extension BananaModel {
    public static func decode(
        from jsonData: Data,
        path: [BananaPathItem] = []
    ) -> Self {
        let doc = jsonData.withUnsafeBytes {
            yyjson_read($0.bindMemory(to: CChar.self).baseAddress, jsonData.count, 0)
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
        from jsonString: String,
        path: [BananaPathItem] = [],
        encoding: String.Encoding = .utf8
    ) -> Self {
        if let jsonData = jsonString.data(using: encoding) {
            decode(from: jsonData, path: path)
        } else {
            .init(json: .init(pointer: nil))
        }
    }
}

extension Dictionary where Key == String, Value: BananaModel {
    public static func decode(
        from jsonData: Data,
        path: [BananaPathItem] = []
    ) -> Self {
        let doc = jsonData.withUnsafeBytes {
            yyjson_read($0.bindMemory(to: CChar.self).baseAddress, jsonData.count, 0)
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
        from jsonString: String,
        path: [BananaPathItem] = [],
        encoding: String.Encoding = .utf8
    ) -> Self {
        if let jsonData = jsonString.data(using: encoding) {
            decode(from: jsonData, path: path)
        } else {
            [:]
        }
    }
}

extension Array where Element: BananaModel {
    public static func decode(
        from jsonData: Data,
        path: [BananaPathItem] = []
    ) -> Self {
        let doc = jsonData.withUnsafeBytes {
            yyjson_read($0.bindMemory(to: CChar.self).baseAddress, jsonData.count, 0)
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
        from jsonString: String,
        path: [BananaPathItem] = [],
        encoding: String.Encoding = .utf8
    ) -> Self {
        if let jsonData = jsonString.data(using: encoding) {
            decode(from: jsonData, path: path)
        } else {
            []
        }
    }
}
