//
//  Repository.swift
//  
//
//  Created by Barbera Cordoba, Rafael on 28/08/2020.
//

import Foundation

public protocol DomainMappeable: APIRequest {
    associatedtype Domain
    static func convert(_ response: APIResponse) async throws -> Domain
}

public class Repository<Domain> {
    let client: APIClient

    public init(_ client: APIClient) {
        self.client = client
    }

    public func fetch<Request>(_ request: Request) async throws -> Domain
    where
        Request: DomainMappeable,
        Request.Domain == Domain
    {
        let response = try await client.send(request)
        return try await Request.convert(response)
    }
}

extension Repository
    where Domain: APIStorable,
    Domain.Request: DomainMappeable,
    Domain.Request.Domain == Domain
{

    public func save(_ entity: Domain) async throws -> Domain {
        let request = entity.request
        guard request.method.isSave else {
            throw "You need POST, PUT, PATCH or DELETE request"
        }
        let response = try await client.send(request)
        return try await Domain.Request.convert(response)
    }
}
