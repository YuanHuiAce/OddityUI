////
//// Newinfo.swift
////
//// Generated by swagger-codegen
//// https://github.com/swagger-api/swagger-codegen
////
//
//import Foundation
//
//
////open class Newinfo: JSONEncodable {
////    /** 返回请求状态码 */
////    open var code: Int32?
////    open var data: NewinfoData?
////
////    public init() {}
////
////    // MARK: JSONEncodable
////    func encodeToJSON() -> AnyObject {
////        var nillableDictionary = [String:AnyObject?]()
////        nillableDictionary["code"] = self.code?.encodeToJSON()
////        nillableDictionary["data"] = self.data?.encodeToJSON()
////        let dictionary: [String:AnyObject] = APIHelper.rejectNil(nillableDictionary) ?? [:]
////        return dictionary as AnyObject
////    }
////}
