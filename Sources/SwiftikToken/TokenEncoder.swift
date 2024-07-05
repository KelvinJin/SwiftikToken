//
//  TokenEncoder.swift
//
//
//  Created by Jin Wang on 2/7/2024.
//

import Foundation
import RegexBuilder

struct TokenEncoder {
    
    enum Error: Swift.Error {
        case containsDisallowedSpecialToken
    }
    
    let tokenizer: BytePairTokenizer
    let specialTokens: Set<String>
    
    func encode(
        text: String,
        allowedSpecial: Set<String>, 
        disallowedSpecial: Set<String>
    ) throws -> [Token] {
        let allowedSpecialSet = if allowedSpecial.count == 1, allowedSpecial.first == "all" {
            specialTokens
        } else {
            allowedSpecial
        }
        
        let disallowedSpecialSet = if disallowedSpecial.count == 1, disallowedSpecial.first == "all" {
            specialTokens.subtracting(allowedSpecialSet)
        } else {
            disallowedSpecial
        }
        
        if disallowedSpecialSet.contains(where: { text.contains($0) }) {
            throw Error.containsDisallowedSpecialToken
        }
        
        return try tokenizer.encode(
            text,
            allowedSpecialTokens: allowedSpecialSet
        )
    }
}
