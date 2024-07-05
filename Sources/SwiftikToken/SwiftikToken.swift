import Foundation

public struct Tiktoken {
    
    enum Error: Swift.Error {
        case vocabularyFileNotFound
    }
    
    let encoding: Encoding
    private let loader = Loader()
    
    public init(encoding: Encoding) {
        self.encoding = encoding
    }
    
    public func encode(
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
        let regex = try encoding.pattern.makeRegex()
        let tokenEncoder = TokenEncoder(
            encoder: encoder,
            specialTokenEncoder: encoding.specialTokenEncoder,
            regex: regex
        )
        
        return try Tokenizer(
            encoder: tokenEncoder,
            specialTokens: encoding.specialTokens
        ).encode(
            text: text,
            allowedSpecial: allowedSpecial,
            disallowedSpecial: disallowedSpecial
        )
    }
}
