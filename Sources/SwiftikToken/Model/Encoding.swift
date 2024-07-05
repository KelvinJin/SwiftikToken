//
//  Encoding.swift
//
//
//  Created by Jin Wang on 4/7/2024.
//

import Foundation

/// Each encoding file is a map between byte sequences and their ranks/tokens.
enum Encoding: String {
    case cl100k = "cl100k_base"
    case o200k = "o200k_base"
    case p50k = "p50k_base"
    case r50k = "r50k_base"
    
    var specialTokenEncoder: Encoder {
        switch self {
        case .cl100k:
            return Encoder(raw: [
                SpecialToken.endOfText.rawValue: 100257,
                SpecialToken.fimPrefix.rawValue: 100258,
                SpecialToken.fimMiddle.rawValue: 100259,
                SpecialToken.fimSuffix.rawValue: 100260,
                SpecialToken.endOfPrompt.rawValue: 100276
            ])
        case .o200k:
            return BytePairEncoder(raw: [
                SpecialToken.endOfText.rawValue: 199999,
                SpecialToken.endOfPrompt.rawValue: 200018
            ])
        case .p50k:
            return BytePairEncoder(raw: [
                SpecialToken.endOfText.rawValue: 50256
            ])
        case .r50k:
            return BytePairEncoder(raw: [
                SpecialToken.endOfText.rawValue: 50256
            ])
        }
    }
    
    var specialTokens: Set<String> {
        return Set(specialTokensEncoder.data.keys.map { String(data: $0, encoding: .utf8)! })
    }
    
    var pattern: Pattern {
        switch self {
        case .cl100k:
            return .p100k
        case .o200k:
            return .o200k
        case .p50k:
            return .p50k
        case .r50k:
            return .p50k
        }
    }
}
