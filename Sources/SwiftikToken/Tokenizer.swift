//
//  Tokenizer.swift
//
//
//  Created by Jin Wang on 28/6/2024.
//

import Foundation

struct Tokenizer {
    
    enum Error: Swift.Error {
        case specialTokenMissingFromVocabulary
    }
    
    let encoder: Encoder
    let specialTokenEncoder: Encoder
    let regex: Regex<AnyRegexOutput>
    
    private let encoding = BytePairEncoding()
    
    init(
        encoder: BytePairEncoder,
        specialTokensEncoder: BytePairEncoder,
        regex: Regex<AnyRegexOutput>
    ) {
        self.encoder = encoder
        var map = [Int: ByteString]()
        encoder.data.forEach { key, value in
            map[value] = key
        }
        self.decoder = map
        
        self.specialTokensEncoder = specialTokensEncoder
        var specialMap = [Int: ByteString]()
        specialTokensEncoder.data.forEach { key, value in
            specialMap[value] = key
        }
        
        self.specialTokensDecoder = specialMap
        self.regex = regex
    }
    
    func encode(
        _ text: String,
        allowedSpecialTokens: Set<String>
    ) throws -> [Token] {
        
        var encodedTokens = [Token]()
        var startIndex = text.startIndex
        // var count = 0
        
        while true {
            var slice = String(text[startIndex...])
            
            let nextSpecialMatch = allowedSpecialTokens.findMatch(in: slice)
            if let match = nextSpecialMatch {
                slice = String(slice[...match.index])
            }
            
            let matches = slice.matches(of: regex)
            
            // Add encoded tokens
            for match in matches {
                let segment = slice[match.range]
                let piece = segment.data(using: .utf8)!
                
                if let token = encoder[piece] {
                    encodedTokens.append(token)
                } else {
                    let tokens = try encoding.encode(piece: piece, encoder: encoder)
                    encodedTokens.append(contentsOf: tokens)
                }
            }
            
            // Add special tokens and end looping if no special token
            if let match = nextSpecialMatch {
                let special = match.value
                let encoded = special.data(using: .utf8)!
                if let token = specialTokensEncoder[encoded] {
                    encodedTokens.append(token)
                } else {
                    throw Error.specialTokenMissingFromVocabulary
                }
                
                startIndex = text.index(match.index, offsetBy: match.value.count)
            } else {
                break
            }
        }
        
        return encodedTokens
    }
}

struct Match {
    let index: String.Index
    let value: String
}

extension Collection where Element == String {
    func findMatch(in text: String) -> Match? {
        var minIndex = text.endIndex
        var value: String? = nil
        
        for element in self {
            if let index = text.range(of: element)?.lowerBound, 
                index < minIndex {
                minIndex = index
                value = element
            }
        }
        
        return value.flatMap { Match(index: minIndex, value: $0) }
    }
}
