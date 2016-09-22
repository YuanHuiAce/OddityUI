import Foundation

class SimpleRequest{
    
    static var basePath = "http://bdp.deeporiginalx.com/v2"
    
    /// Creates an instance with the specified `method`,`encoding`, `urlString` and `headers`.
    ///
    /// - parameter url:      The URL.
    /// - parameter method:   The HTTP method.
    /// - parameter encoding: The HTTP encoding. URLEncoding.default by default.
    /// - parameter headers:  The HTTP headers. `nil` by default.
    ///
    /// - returns: The new `URLRequest` instance.
    class func budileRequest(_ url: URLConvertible,method: HTTPMethod = .get,parameters: Parameters? = nil,encoding: ParameterEncoding = URLEncoding.default,headers: HTTPHeaders? = nil) -> URLRequest{
        var urlRequest = try! URLRequest(url: url, method: method, headers: headers)
        let encodedURLRequest = try! encoding.encode(&urlRequest, with: parameters)
        return encodedURLRequest
    }
    

}


extension URLRequest{

    /// 创建一个 URLSessionDataTask ，请求对象。 使用参数 request 和 一个回调函数
    ///
    /// - parameter request:             请求对象.
    /// - parameter completionHandler:   完成后的回调对象.
    ///
    /// - returns: The new `URLSessionDataTask` instance.
    @discardableResult
    func request( completionHandler : @escaping ( Dictionary <String,AnyObject>? , String?,HTTPURLResponse?) -> Swift.Void)-> URLSessionDataTask{
        let dataTask = URLSession.shared.dataTask(with: self) { (data, res, error) in
            DispatchQueue.main.async {
                var responrs:HTTPURLResponse? = nil
                if let respones = res as? HTTPURLResponse { responrs = respones }
                guard let rdata = data else { return completionHandler(nil, "数据获取失败" ,responrs) }
                do{
                    guard let dic = try JSONSerialization.jsonObject(with: rdata, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary <String,AnyObject> else{ return completionHandler(nil, "数据格式问题" ,responrs) }
                    completionHandler(dic, nil ,responrs)
                }catch{
                    completionHandler(nil, "json数据转换失败" ,responrs)
                }
            }
        }
        dataTask.resume()
        return dataTask
    }
    
    
    /// 给一个已经存在的URLRequest新增Header.
    ///
    /// - parameter headers: The HTTP headers. `nil` by default.
    ///
    /// - returns: 返回这个新增完成后的对象
    mutating func addHeaders(headers:[String:String]) -> URLRequest{
        for (key,value) in headers {
            self.addValue(value, forHTTPHeaderField: key)
        }
        return self
    }
}


/// A dictionary of headers to apply to a `URLRequest`.
typealias HTTPHeaders = [String: String]

extension URLRequest {
    /// Creates an instance with the specified `method`, `urlString` and `headers`.
    ///
    /// - parameter url:     The URL.
    /// - parameter method:  The HTTP method.
    /// - parameter headers: The HTTP headers. `nil` by default.
    ///
    /// - returns: The new `URLRequest` instance.
    init(url: URLConvertible, method: HTTPMethod, headers: HTTPHeaders? = nil) throws {
        let url = try url.asURL()
        self.init(url: url)
        
        httpMethod = method.rawValue
        
        if let headers = headers {
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
    }
}


/// Types adopting the `URLConvertible` protocol can be used to construct URLs, which are then used to construct
/// URL requests.
protocol URLConvertible {
    /// Returns a URL that conforms to RFC 2396 or throws an `Error`.
    ///
    /// - throws: An `Error` if the type cannot be converted to a `URL`.
    ///
    /// - returns: A URL or throws an `Error`.
    func asURL() throws -> URL
}

extension String: URLConvertible {
    /// Returns a URL if `self` represents a valid URL string that conforms to RFC 2396 or throws an `AFError`.
    ///
    /// - throws: An `AFError.invalidURL` if `self` is not a valid URL string.
    ///
    /// - returns: A URL or throws an `AFError`.
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw NSError() }
        return url
    }
}

extension URL: URLConvertible {
    /// Returns self.
    public func asURL() throws -> URL { return self }
}

extension URLComponents: URLConvertible {
    /// Returns a URL if `url` is not nil, otherise throws an `Error`.
    ///
    /// - throws: An `AFError.invalidURL` if `url` is `nil`.
    ///
    /// - returns: A URL or throws an `AFError`.
    public func asURL() throws -> URL {
        guard let url = url else { throw NSError() }
        return url
    }
}

/// HTTP method definitions.
///
/// See https://tools.ietf.org/html/rfc7231#section-4.3
enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

// MARK: -

/// A dictionary of parameters to apply to a `URLRequest`.
typealias Parameters = [String: Any]

/// A type used to define how a set of parameters are applied to a `URLRequest`.
protocol ParameterEncoding {
    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `AFError.parameterEncodingFailed` error if encoding fails.
    ///
    /// - returns: The encoded request.
    func encode(_ urlRequest: inout URLRequest, with parameters: Parameters?) throws -> URLRequest
}

// MARK: -

/// Creates a url-encoded query string to be set as or appended to any existing URL query string or set as the HTTP
/// body of the URL request. Whether the query string is set or appended to any existing URL query string or set as
/// the HTTP body depends on the destination of the encoding.
///
/// The `Content-Type` HTTP header field of an encoded request with HTTP body is set to
/// `application/x-www-form-urlencoded; charset=utf-8`. Since there is no published specification for how to encode
/// collection types, the convention of appending `[]` to the key for array values (`foo[]=1&foo[]=2`), and appending
/// the key surrounded by square brackets for nested dictionary values (`foo[bar]=baz`).
struct URLEncoding: ParameterEncoding {
    
    // MARK: Helper Types
    
    /// Defines whether the url-encoded query string is applied to the existing query string or HTTP body of the
    /// resulting URL request.
    ///
    /// - methodDependent: Applies encoded query string result to existing query string for `GET`, `HEAD` and `DELETE`
    ///                    requests and sets as the HTTP body for requests with any other HTTP method.
    /// - queryString:     Sets or appends encoded query string result to existing query string.
    /// - httpBody:        Sets encoded query string result as the HTTP body of the URL request.
    public enum Destination {
        case methodDependent, queryString, httpBody
    }
    
    // MARK: Properties
    
    /// Returns a default `URLEncoding` instance.
    public static var `default`: URLEncoding { return URLEncoding() }
    
    /// Returns a `URLEncoding` instance with a `.methodDependent` destination.
    public static var methodDependent: URLEncoding { return URLEncoding() }
    
    /// Returns a `URLEncoding` instance with a `.queryString` destination.
    public static var queryString: URLEncoding { return URLEncoding(destination: .queryString) }
    
    /// Returns a `URLEncoding` instance with an `.httpBody` destination.
    public static var httpBody: URLEncoding { return URLEncoding(destination: .httpBody) }
    
    /// The destination defining where the encoded query string is to be applied to the URL request.
    public let destination: Destination
    
    // MARK: Initialization
    
    /// Creates a `URLEncoding` instance using the specified destination.
    ///
    /// - parameter destination: The destination defining where the encoded query string is to be applied.
    ///
    /// - returns: The new `URLEncoding` instance.
    public init(destination: Destination = .methodDependent) {
        self.destination = destination
    }
    
    // MARK: Encoding
    
    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `Error` if the encoding process encounters an error.
    ///
    /// - returns: The encoded request.
    public func encode(_ urlRequest: inout URLRequest, with parameters: Parameters?) throws -> URLRequest {
        
        guard let parameters = parameters else { return urlRequest }
        
        if let method = HTTPMethod(rawValue: urlRequest.httpMethod ?? "GET"), encodesParametersInURL(with: method) {
            guard let url = urlRequest.url else {
                throw NSError(domain: "请求路径解析错误", code: 500, userInfo: nil)
            }
            
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
                urlComponents.percentEncodedQuery = percentEncodedQuery
                urlRequest.url = urlComponents.url
            }
        } else {
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            }
            
            urlRequest.httpBody = query(parameters).data(using: .utf8, allowLossyConversion: false)
        }
        
        return urlRequest
    }
    
    /// Creates percent-escaped, URL encoded query string components from the given key-value pair using recursion.
    ///
    /// - parameter key:   The key of the query component.
    /// - parameter value: The value of the query component.
    ///
    /// - returns: The percent-escaped, URL encoded query string components.
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    /// Returns a percent-escaped string following RFC 3986 for a query string key or value.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    ///
    /// - parameter string: The string to be percent-escaped.
    ///
    /// - returns: The percent-escaped string.
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    }
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    private func encodesParametersInURL(with method: HTTPMethod) -> Bool {
        switch destination {
        case .queryString:
            return true
        case .httpBody:
            return false
        default:
            break
        }
        
        switch method {
        case .get, .head, .delete:
            return true
        default:
            return false
        }
    }
}

// MARK: -

/// Uses `JSONSerialization` to create a JSON representation of the parameters object, which is set as the body of the
/// request. The `Content-Type` HTTP header field of an encoded request is set to `application/json`.
struct JSONEncoding: ParameterEncoding {
    
    // MARK: Properties
    
    /// Returns a `JSONEncoding` instance with default writing options.
    public static var `default`: JSONEncoding { return JSONEncoding() }
    
    /// Returns a `JSONEncoding` instance with `.prettyPrinted` writing options.
    public static var prettyPrinted: JSONEncoding { return JSONEncoding(options: .prettyPrinted) }
    
    /// The options for writing the parameters as JSON data.
    public let options: JSONSerialization.WritingOptions
    
    // MARK: Initialization
    
    /// Creates a `JSONEncoding` instance using the specified options.
    ///
    /// - parameter options: The options for writing the parameters as JSON data.
    ///
    /// - returns: The new `JSONEncoding` instance.
    public init(options: JSONSerialization.WritingOptions = []) {
        self.options = options
    }
    
    // MARK: Encoding
    
    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `Error` if the encoding process encounters an error.
    ///
    /// - returns: The encoded request.
    public func encode( _ urlRequest: inout URLRequest, with parameters: Parameters?) throws -> URLRequest {
        guard let parameters = parameters else { return urlRequest }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: options)
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            urlRequest.httpBody = data
        } catch {
            throw NSError(domain: "解析JSON 失败", code: 500, userInfo: nil)
        }
        
        return urlRequest
    }
}

// MARK: -

/// Uses `PropertyListSerialization` to create a plist representation of the parameters object, according to the
/// associated format and write options values, which is set as the body of the request. The `Content-Type` HTTP header
/// field of an encoded request is set to `application/x-plist`.
struct PropertyListEncoding: ParameterEncoding {
    
    // MARK: Properties
    
    /// Returns a default `PropertyListEncoding` instance.
    public static var `default`: PropertyListEncoding { return PropertyListEncoding() }
    
    /// Returns a `PropertyListEncoding` instance with xml formatting and default writing options.
    public static var xml: PropertyListEncoding { return PropertyListEncoding(format: .xml) }
    
    /// Returns a `PropertyListEncoding` instance with binary formatting and default writing options.
    public static var binary: PropertyListEncoding { return PropertyListEncoding(format: .binary) }
    
    /// The property list serialization format.
    public let format: PropertyListSerialization.PropertyListFormat
    
    /// The options for writing the parameters as plist data.
    public let options: PropertyListSerialization.WriteOptions
    
    // MARK: Initialization
    
    /// Creates a `PropertyListEncoding` instance using the specified format and options.
    ///
    /// - parameter format:  The property list serialization format.
    /// - parameter options: The options for writing the parameters as plist data.
    ///
    /// - returns: The new `PropertyListEncoding` instance.
    public init(
        format: PropertyListSerialization.PropertyListFormat = .xml,
        options: PropertyListSerialization.WriteOptions = 0)
    {
        self.format = format
        self.options = options
    }
    
    // MARK: Encoding
    
    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `Error` if the encoding process encounters an error.
    ///
    /// - returns: The encoded request.
    public func encode(_ urlRequest: inout URLRequest, with parameters: Parameters?) throws -> URLRequest {
        
        guard let parameters = parameters else { return urlRequest }
        
        do {
            let data = try PropertyListSerialization.data(
                fromPropertyList: parameters,
                format: format,
                options: options
            )
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/x-plist", forHTTPHeaderField: "Content-Type")
            }
            
            urlRequest.httpBody = data
        } catch {
            throw NSError(domain: "解析JSON 失败", code: 500, userInfo: nil)
        }
        
        return urlRequest
    }
}

// MARK: -

extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
