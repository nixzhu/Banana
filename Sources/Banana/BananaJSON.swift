import Foundation
import yyjson

@dynamicMemberLookup public struct BananaJSON {
    private let pointer: UnsafeMutablePointer<yyjson_val>?

    public init(pointer: UnsafeMutablePointer<yyjson_val>?) {
        self.pointer = pointer
    }

    public subscript(dynamicMember member: String) -> Self {
        self[member]
    }

    public subscript(key: String) -> Self {
        .init(pointer: yyjson_obj_get(pointer, key))
    }

    public subscript(index: Int) -> Self {
        .init(pointer: yyjson_arr_get(pointer, index))
    }
}

extension BananaJSON {
    public func rawBool() -> Bool? {
        if yyjson_is_bool(pointer) {
            return yyjson_get_bool(pointer)
        }

        return nil
    }

    public func rawInt() -> Int? {
        if yyjson_is_int(pointer) {
            return .init(yyjson_get_sint(pointer))
        }

        return nil
    }

    public func rawDouble() -> Double? {
        if yyjson_is_num(pointer) {
            return yyjson_get_num(pointer)
        }

        return nil
    }

    public func rawString() -> String? {
        if let cString = yyjson_get_str(pointer) {
            return .init(cString: cString)
        }

        return nil
    }
}

extension BananaJSON {
    public func dictionary() -> [String: Self] {
        guard yyjson_obj_size(pointer) > 0 else {
            return [:]
        }

        var result: [String: Self] = [:]

        var iter = yyjson_obj_iter()
        yyjson_obj_iter_init(pointer, &iter)

        while true {
            if let key = yyjson_obj_iter_next(&iter),
               let value = yyjson_obj_iter_get_val(key)
            {
                let keyString = yyjson_get_str(key).flatMap {
                    String(cString: $0)
                }

                if let keyString {
                    result[keyString] = .init(pointer: value)
                } else {
                    assertionFailure("Should not be here!")
                }
            } else {
                break
            }
        }

        return result
    }
}

extension BananaJSON {
    public func array() -> [Self] {
        guard yyjson_arr_size(pointer) > 0 else {
            return []
        }

        var result: [Self] = []

        var iter = yyjson_arr_iter()
        yyjson_arr_iter_init(pointer, &iter)

        while true {
            if let value = yyjson_arr_iter_next(&iter) {
                result.append(.init(pointer: value))
            } else {
                break
            }
        }

        return result
    }
}
