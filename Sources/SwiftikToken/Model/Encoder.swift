//
//  Encoder.swift
//
//
//  Created by Jin Wang on 4/7/2024.
//

import Foundation

/// A encoder is simply a map between a byte sequence and its token/rank.
/// It's essentially what the tiktoken file provides us with.
typealias Encoder = [Data: Token]

extension Encoder {
    
    enum Error: Swift.Error {
        /// Throw when string key cannot be encoded.
        case invalidKey
    }
    
    init(raw: [String: Token]) throws {
        var map = [Data: Token]()
        for (key, value) in raw {
            guard let data = key.data(using: .utf8) else {
                throw Error.invalidKey
            }
            
            map[data] = value
        }
        self = map
    }
}
