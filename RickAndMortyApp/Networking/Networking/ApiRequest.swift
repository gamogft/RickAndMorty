import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"

    var isSave: Bool {
        switch self {
        case .get:
            false
        case .post, .put, .patch, .delete:
            true
        }
    }
}

extension Encodable {
    var asQueryItems: [URLQueryItem] {
        do {
            return try URLQueryItemEncoder.encode(self)
        } catch {
            fatalError("Wrong parameters: \(error)")
        }
    }
}

public typealias EmptyResponse = Void

public protocol APIRequest {
    associatedtype APIResponse
    
    var resourcePath: String { get }
    var method: HTTPMethod { get }
    var stubName: String { get }
    var needsAccessToken: Bool { get }
    var body: Data? { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem] { get }
    
    func generateURLrequest(_ baseURL: URL) -> URLRequest
    
    func accept(_ response: HTTPURLResponse) -> Bool
    func parse(_ response: HTTPURLResponse, data: Data) async throws -> APIResponse
    func error(_ response: HTTPURLResponse, data: Data) -> Error
}

public extension APIRequest {
    var method: HTTPMethod { .get }
    var needsAccessToken: Bool { true }
    var stubName: String { generateStubFilename() }
    var body: Data? { nil }
    var headers: [String: String] { [:] }
    var queryItems: [URLQueryItem] { [] }
    
    func generateStubFilename() -> String {
        return "\(method.rawValue.uppercased())_\(resourcePath.replacingOccurrences(of:"/", with: "-"))"
    }

    func generateURLrequest(_ baseURL: URL) -> URLRequest {
        var urlRequest = appendURLParameters(baseURL)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = body
        urlRequest.allHTTPHeaderFields = headers
        return urlRequest
    }
    
    func accept(_ response: HTTPURLResponse) -> Bool {
        return 200..<300 ~= response.statusCode
    }

    private func appendURLParameters(_ baseURL: URL) -> URLRequest {
        guard
            let url = URL(string: resourcePath, relativeTo: baseURL),
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            else {
                fatalError("Bad resourceName: \(resourcePath)")
        }
        
        let customQueryItems = queryItems
        components.queryItems = customQueryItems.isEmpty ? nil : customQueryItems
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        guard let finalURL = components.url else { fatalError("Bar URLComponents construction") }
        return URLRequest(url: finalURL)
    }
    
}

public protocol JSONAPIRequest: APIRequest {
    var decoder: JSONDecoder { get }
}

public extension JSONAPIRequest {
    var decoder: JSONDecoder {
        JSONDecoder()
    }
}

public extension JSONAPIRequest where APIResponse: Decodable {
    func parse(_ response: HTTPURLResponse, data: Data) async throws -> APIResponse {
        do {
            let responseObject = try decoder.decode(APIResponse.self, from: data)
            return responseObject
        } catch {
            throw error
        }
    }
    
    func error(_ response: HTTPURLResponse, data: Data) -> Error {
        return NetworkError.undefinedNetworkError
    }
}

public extension APIRequest where APIResponse == Void {
    func parse(_ response: HTTPURLResponse, data: Data) async throws -> Void {
        return
    }
}
