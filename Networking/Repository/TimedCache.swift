//
//  TimedCache.swift
//  
//
//  Created by Barbera Cordoba, Rafael on 28/08/2020.
//

import Foundation

class TimedCache<A> {
    let lifetime: TimeInterval
    var cache: [String: (value: A, validUntil: Date)]
    var currentDate: () -> Date

    init(_ lifetime: TimeInterval, currentDate: @escaping () -> Date = { Date() }) {
        self.lifetime = lifetime
        self.cache = [:]
        self.currentDate = currentDate
    }

    subscript(key: String) -> A? {
        get {
            guard
                let (value, validUntil) = cache[key],
                currentDate() <= validUntil else { return nil }

            return value
        }

        set {
            if let value = newValue {
                let validuntil = currentDate().addingTimeInterval(lifetime)
                cache[key] = (value, validuntil)
            } else {
                cache[key] = nil
            }
        }
    }
}
