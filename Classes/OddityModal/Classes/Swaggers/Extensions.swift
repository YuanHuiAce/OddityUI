// Extensions.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import UIKit

extension Bool: JSONEncodable {
    func encodeToJSON() -> AnyObject { return self as AnyObject }
}

extension Float: JSONEncodable {
    func encodeToJSON() -> AnyObject { return self as AnyObject }
}

extension Int: JSONEncodable {
    func encodeToJSON() -> AnyObject { return self as AnyObject }
}

extension Int32: JSONEncodable {
    func encodeToJSON() -> AnyObject { return NSNumber(value: self as Int32) }
}

extension Int64: JSONEncodable {
    func encodeToJSON() -> AnyObject { return NSNumber(value: self as Int64) }
}

extension Double: JSONEncodable {
    func encodeToJSON() -> AnyObject { return self as AnyObject }
}

extension String: JSONEncodable {
    func encodeToJSON() -> AnyObject { return self as AnyObject }
}

private func encodeIfPossible<T>(_ object: T) -> AnyObject {
    if object is JSONEncodable {
        return (object as! JSONEncodable).encodeToJSON()
    } else {
        return object as AnyObject
    }
}

//extension Array: JSONEncodable {
//    func encodeToJSON() -> Any {
//        return self.map(encodeIfPossible)
//    }
//}

extension Dictionary: JSONEncodable {
    func encodeToJSON() -> AnyObject {
        var dictionary = [AnyHashable: Any]()
        for (key, value) in self {
            dictionary[key as! NSObject] = encodeIfPossible(value)
        }
        return dictionary as AnyObject
    }
}


private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter
}()

extension Date: JSONEncodable {
    func encodeToJSON() -> AnyObject {
        return dateFormatter.string(from: self) as AnyObject
    }
}


