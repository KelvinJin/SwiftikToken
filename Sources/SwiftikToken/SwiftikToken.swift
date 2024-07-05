import Foundation

struct Tiktoken {
    
    enum Error: Swift.Error {
        case vocabularyFileNotFound
    }
    
    let encoding: Encoding
    private let loader = BPELoader()
    
    func encode(
        text: String,
        allowedSpecial: Set<String> = Set(),
        disallowedSpecial: Set<String> = Set(arrayLiteral: "all")
    ) async throws -> [Token] {
        guard let fileURL = Bundle.module.url(
            forResource: encoding.rawValue,
            withExtension: "tiktoken"
        ) else {
            throw Error.vocabularyFileNotFound
        }
        
        let encoder = try await loader.load(fileURL: fileURL)
        let tokenizer = BytePairTokenizer(
            encoder: encoder,
            specialTokensEncoder: encoding.specialTokensEncoder,
            regex: encoding.pattern.regex
        )
        
        return try TokenEncoder(
            tokenizer: tokenizer,
            specialTokens: encoding.specialTokens
        ).encode(
            text: text,
            allowedSpecial: allowedSpecial,
            disallowedSpecial: disallowedSpecial
        )
    }
}
