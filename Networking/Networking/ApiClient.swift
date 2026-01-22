//
//  ApiClient.swift
//  TSBNetwork
//
//  Created by Barbera Cordoba, Rafael on 13/12/2019.
//

import Foundation

public protocol APIClient {
    func send<T: APIRequest>(_ request: T) async throws -> T.APIResponse
    var logger: NetworkLoggerProtocol { get }
    var clientHeaders: (() -> [String: String])? { get set }
}

open class GFTAPIClient: APIClient {
    private let baseURL: URL
    private let session: URLSession
    private let systemErrorHandler: ((Error?) -> Error?)?
    private let responseErrorHandler: ((HTTPURLResponse) -> Error?)?
    private let recorder: NetworkRecorderProtocol?
    private let responseQueue: DispatchQueue
    public let logger: NetworkLoggerProtocol
    public var clientHeaders: (() -> [String: String])?
    
    public init(
        baseURL: URL,
        session: URLSession = URLSession(configuration: URLSessionConfiguration.default),
        responseQueue: DispatchQueue = .main,
        clientHeaders: @escaping () -> [String: String] = {[:]},
        systemErrorHandler: ((Error?) -> Error?)? = nil,
        responseErrorHandler: ((HTTPURLResponse) -> Error?)? = nil,
        logger: NetworkLoggerProtocol = APILogger(),
        recorder: NetworkRecorderProtocol? = nil
    ) {
        self.baseURL = baseURL
        self.session = session
        self.responseQueue = responseQueue
        self.clientHeaders = clientHeaders
        self.systemErrorHandler = systemErrorHandler
        self.responseErrorHandler = responseErrorHandler
        self.logger = logger
        self.recorder = recorder
    }

    public func send<T: APIRequest>(_ request: T) async throws -> T.APIResponse {
        let endpoint = self.urlRequest(for: request)
        logger.showLog(endpoint)
        do {
            let (data, response) = try await session.data(for: endpoint)
            self.logger.showLog(data: data, response: response, error: nil)
            let result = try await handleResponse(request, data: data, response: response)
            return result
        } catch {
            self.logger.showLog(data: nil, response: nil, error: error)
            throw error
        }
    }
    
    public func urlRequest<T: APIRequest>(for request: T) -> URLRequest {
        var urlRequest = request.generateURLrequest(baseURL)
        if let headers = clientHeaders?() {
            headers.forEach { (key, value) in
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        return urlRequest
    }
    
    func handleResponse<T: APIRequest>(_ request: T, data: Data, response: URLResponse) async throws -> T.APIResponse {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if request.accept(httpResponse) {
            if let recorder = recorder {
                recorder.record(request: request, data: data)
            }
            return try await request.parse(httpResponse, data: data)
        } else {
            let error = request.error(httpResponse, data: data)
            if let error = error as? NetworkError, error == .undefinedNetworkError {
                throw responseErrorHandler?(httpResponse) ?? error
            } else {
                throw error
            }
        }
    }
}
