//
//  BytePairEncoding.swift
//
//
//  Created by Jin Wang on 3/7/2024.
//

import Foundation

struct BytePairEncoding {
    
    enum Error: Swift.Error {
        case emptyPiece
    }
    
    struct Part {
        let index: Data.Index
        var token: Token?
    }
    
    func encode(piece: ByteString, encoder: BytePairEncoder) throws -> [Token] {
        guard piece.count > 0 else {
            throw Error.emptyPiece
        }
        
        guard piece.count > 1 else {
            return [encoder[piece] ?? .unknown]
        }
        
        var parts = [Part]()
        
        for i in 0..<piece.count + 1 {
            parts.append(Part(index: i, token: nil))
        }
        
        for i in 0..<piece.count - 2 {
            parts[i] = Part(
                index: i,
                token: token(
                    for: piece,
                    encoder: encoder,
                    parts: parts,
                    startIndex: i,
                    skip: 0
                )
            )
        }
        
        while parts.count > 1 {
            guard let minIndex = indexOfMinToken(parts: parts) else { break }
            
            parts[minIndex].token = token(
                for: piece,
                encoder: encoder,
                parts: parts, 
                startIndex: minIndex,
                skip: 1
            )
            
            if minIndex > 0 {
                let prevIndex = minIndex - 1
                parts[prevIndex].token = token(
                    for: piece,
                    encoder: encoder,
                    parts: parts,
                    startIndex: prevIndex,
                    skip: 1
                )
            }
            
            parts.remove(at: minIndex + 1)
        }
        
        var tokens = [Token]()
        for i in 0..<(parts.count - 1) {
            let range = parts[i].index..<parts[i + 1].index
            tokens.append(
                encoder[piece.subdata(in: range)] ?? .unknown
            )
        }
        return tokens
    }
    
    private func token(
        for piece: ByteString,
        encoder: BytePairEncoder,
        parts: [Part],
        startIndex: Int,
        skip: Int
    ) -> Token? {
        guard startIndex + skip + 2 < parts.count else { return nil }
        
        
        let data = piece.subdata(
            in: parts[startIndex].index..<parts[startIndex + skip + 2].index
        )
        return encoder[data]
    }
    
    private func indexOfMinToken(parts: [Part]) -> Int? {
        var minToken: Token? = nil
        var minIndex: Int? = nil
        
        for i in parts.indices {
            if let token = parts[i].token {
                if let min = minToken {
                    if token < min {
                        minToken = token
                        minIndex = i
                    }
                } else {
                    minToken = token
                    minIndex = i
                }
            }
        }
        
        return minIndex
    }
}
