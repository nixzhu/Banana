import Foundation
import yyjson

@dynamicMemberLookup public struct BananaJSON {
    @usableFromInline let pointer: UnsafeMutablePointer<yyjson_val>?

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
    @inlinable public func rawBool() -> Bool? {
        if yyjson_is_bool(pointer) {
            return yyjson_get_bool(pointer)
        }

        return nil
    }

    @inlinable public func rawInt() -> Int? {
        if yyjson_is_int(pointer) {
            return .init(yyjson_get_sint(pointer))
        }

        return nil
    }

    @inlinable public func rawDouble() -> Double? {
        if yyjson_is_num(pointer) {
            return yyjson_get_num(pointer)
        }

        return nil
    }

    @inlinable public func rawString() -> String? {
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
            if let keyPointer = yyjson_obj_iter_next(&iter),
               let valuePointer = yyjson_obj_iter_get_val(keyPointer)
            {
                let key = yyjson_get_str(keyPointer).flatMap {
                    String(cString: $0)
                }

                if let key {
                    result[key] = .init(pointer: valuePointer)
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
            if let valuePointer = yyjson_arr_iter_next(&iter) {
                result.append(.init(pointer: valuePointer))
            } else {
                break
            }
        }

        return result
    }
}
