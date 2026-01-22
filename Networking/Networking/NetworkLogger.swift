import Foundation

public protocol NetworkLoggerProtocol {
    func showLog(_ request: URLRequest)
    func showLog(data: Data?, response: URLResponse?, error: Error?)
    func showCacheHit(_ request: URLRequest)
    func showCacheClear()
}

public class APILogger: NetworkLoggerProtocol {
    public enum Environment {
        case info
        case debug
        case production
    }
    
    let environment: Environment
    let reporting: ((String) -> Void)?
    
    public static var prettyPrintJSON = false
    
    public init(_ environment: Environment = .debug, reporting: ((String) -> Void)? = nil) {
        self.environment = environment
        self.reporting = reporting
    }

    func outputLog(_ message: String) {
        switch environment {
        case .debug, .info:
            print(message)
            reporting?(message)
        case .production:
            reporting?(message)
        }
    }
    
    public func showLog(_ request: URLRequest) {
        guard let output = buildOutput(request) else { return }
        outputLog(output)
    }
    
    public func showLog(data: Data?, response: URLResponse?, error: Error?) {
        guard let httpResponse = response as? HTTPURLResponse else {
            outputLog("Invalid response")
            return
        }
        
        switch environment {
            case .info, .production:
                break
            case .debug:
                outputLog(log(data: data, response: httpResponse, error: error))
        }
    }

    public func showCacheHit(_ request: URLRequest) {
        var cacheLog = "\n-------- CACHE HIT --------\n"
        cacheLog += "\(request.url?.absoluteString ?? "--")"
        cacheLog += "\n---------------------------\n"
        outputLog(cacheLog)
    }

    public func showCacheClear() {
        outputLog("\n------- CLEAR CACHE -------\n")
    }

    func buildOutput(_ request: URLRequest) -> String? {
        switch environment {
            case .info:
            return request.curlString
            case .debug:
            return "\(request.curlString)\n\(log(request))"
            case .production:
            return nil
        }
    }

    func log(_ request: URLRequest) -> String {
        let urlString = request.url?.absoluteString ?? ""
        let components = NSURLComponents(string: urlString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod!)": ""
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        let host = "\(components?.host ?? "")"
        
        var requestLog = "\n---------- OUT ---------->\n"
        requestLog += "\(urlString)"
        requestLog += "\n\n"
        requestLog += "\(method) \(path)?\(query) HTTP/1.1\n"
        requestLog += "Host: \(host)\n"
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            requestLog += "\(key): \(value)\n"
        }
        if let body = request.httpBody{
            requestLog += "\n\(body.prettyPrintedJSONString ?? "")\n"
        }
        
        requestLog += "\n------------------------->\n";
        return requestLog
    }
    
    
    func log(data: Data?, response: HTTPURLResponse?, error: Error?) -> String {
        let urlString = response?.url?.absoluteString
        let components = NSURLComponents(string: urlString ?? "")
        
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        
        var responseLog = "\n<---------- IN ----------\n"
        if let urlString = urlString {
            responseLog += "\(urlString)"
            responseLog += "\n\n"
        }
        
        if let statusCode =  response?.statusCode{
            responseLog += "HTTP \(statusCode) \(path)?\(query)\n"
        }
        if let host = components?.host{
            responseLog += "Host: \(host)\n"
        }
        for (key,value) in response?.allHeaderFields ?? [:] {
            responseLog += "\(key): \(value)\n"
        }
        if let body = data {
            responseLog += "\n\(body.prettyPrintedJSONString ?? "")\n"
        }
        if let error = error{
            responseLog += "\nError: \(error.localizedDescription)\n"
        }
        
        responseLog += "<------------------------\n";
        return responseLog
    }
}

extension URLRequest {

    public var curlString: String {
        // Logging URL requests in whole may expose sensitive data,
        // or open up possibility for getting access to your user data,
        // so make sure to disable this feature for production builds!

        var result = "curl -k "

        if let method = httpMethod {
            result += "-X \(method) \\\n"
        }

        if let headers = allHTTPHeaderFields {
            for (header, value) in headers {
                result += "-H \"\(header): \(value)\" \\\n"
            }
        }

        if let body = httpBody, !body.isEmpty, let string = String(data: body, encoding: .utf8), !string.isEmpty {
            result += "-d '\(string)' \\\n"
        }

        if let url = url {
            result += url.absoluteString
        }

        return result
    }
}
