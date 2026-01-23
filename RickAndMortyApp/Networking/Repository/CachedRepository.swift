//
//  CachedRepository.swift
//  
//
//  Created by Barbera Cordoba, Rafael on 28/08/2020.
//

import Foundation

public protocol APIStorable {
    associatedtype Request: APIRequest
    var request: Request { get }
}

public protocol Cacheable {
    var cacheKey: String { get }
}

public class CachedRepository<Domain> {
    var repository: Repository<Domain>
    var cache: TimedCache<Domain>

    public init(_ client: APIClient, lifetime: TimeInterval, currentDate: @escaping () -> Date = { Date() }) {
        self.repository = Repository<Domain>(client)
        self.cache = TimedCache(lifetime, currentDate: currentDate)
    }

    public var currentDate: () -> Date {
        get {
            cache.currentDate
        }

        set {
            cache.currentDate = newValue
        }
    }

    public func fetch<Request>(_ request: Request) async throws -> Domain where
        Request: DomainMappeable,
        Request: Cacheable,
        Request.Domain == Domain
    {
        let key = request.cacheKey
        if !request.method.isSave {
            if let cachedValue = cache[key] {
                return cachedValue
            }
        }

        let domain = try await repository.fetch(request)
        cache[key] = domain
        return domain
    }
}

extension CachedRepository
    where Domain: APIStorable,
    Domain: Cacheable,
    Domain.Request: DomainMappeable,
    Domain.Request.Domain == Domain
{

    public func save(_ entity: Domain) async throws -> Domain {
        let domain = try await repository.save(entity)
        let key = domain.cacheKey
        cache[key] = domain
        return domain
    }
}
