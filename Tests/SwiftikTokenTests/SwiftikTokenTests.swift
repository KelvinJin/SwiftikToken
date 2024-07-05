import XCTest
@testable import SwiftikToken

final class SwiftikTokenTests: XCTestCase {
    func testEnglish() async throws {
        let tokenizer = Tiktoken(encoding: .cl100k)
        let tokens = try await tokenizer.encode(text: "hello world")
        XCTAssertEqual([15339, 1917], tokens)
    }
    
    func testChinese() async throws {
        let tokenizer = Tiktoken(encoding: .cl100k)
        let tokens = try await tokenizer.encode(text: "你好世界")
        XCTAssertEqual([57668, 53901, 3574, 244, 98220], tokens)
    }
    
    func testLongText() async throws {
        let tokenizer = Tiktoken(encoding: .cl100k)
        let text = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce commodo, quam eget ultricies ultricies, risus enim bibendum ligula, sit amet venenatis turpis eros et arcu. Nullam eu nisi vitae odio imperdiet maximus. Nunc mollis nisl at nulla viverra, nec feugiat dui efficitur. Maecenas in ligula sit amet ex maximus consequat. Pellentesque auctor, justo at malesuada iaculis, nunc felis finibus dolor, a vehicula tortor mi in risus. Donec tristique urna vel erat ultricies, at hendrerit nunc rutrum. Mauris sagittis, mi sed pellentesque bibendum, orci mauris posuere ipsum, eget vehicula ipsum justo eu libero. Curabitur fringilla risus eget ligula vehicula, quis pharetra turpis interdum. Proin vitae felis velit. Nunc a interdum quam. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vivamus non orci ac risus eleifend mollis.

        这是一段包含中文的文本示例。在这段文字中，我们可以看到不同的汉字和标点符号，用来测试分词器在处理中文时的表现。希望这对您的测试有所帮助。

        Voici un exemple de texte en français pour tester votre tokenizeur. Il contient divers accents et caractères spéciaux utilisés dans la langue française. À vous de voir comment il gère ces éléments !

        Это пример текста на русском языке. В нём содержатся различные русские буквы и знаки препинания. Используйте его для проверки вашего токенизатора.

        Este es un ejemplo de texto en español. Incluye letras con tildes y caracteres especiales propios del idioma español. Úselo para evaluar cómo maneja su tokenizador estos elementos.

        This is an example of text in English. It includes standard English punctuation and words commonly used in the language. Use it to ensure your tokenizer handles English text correctly.
        """
        let expect = [
            33883, 27439, 24578, 2503, 28311, 11, 36240, 59024, 31160, 13,
            94400, 346, 79424, 11, 90939, 70763, 37232, 45439, 37232, 45439, 11,
            10025, 355, 60602, 24768, 25547, 29413, 5724, 11, 2503, 28311, 11457,
            268, 3689, 13535, 57996, 43219, 1880, 15952, 84, 13, 18576, 309, 15925,
            69252, 64220, 87834, 17190, 94942, 31127, 355, 13, 452, 1371, 55509,
            285, 308, 23265, 520, 61550, 18434, 14210, 11, 19591, 1172, 773, 10574,
            294, 2005, 3369, 19195, 324, 13, 11583, 762, 28043, 304, 29413, 5724,
            2503, 28311, 506, 31127, 355, 85987, 13, 89008, 21938, 593, 264, 80322,
            11, 82943, 520, 25000, 86200, 602, 582, 65130, 11, 308, 1371, 18515, 285,
            1913, 34495, 24578, 11, 264, 5275, 292, 5724, 16831, 269, 9686, 304,
            10025, 355, 13, 28457, 66, 490, 97496, 66967, 64, 9231, 2781, 266, 37232,
            45439, 11, 520, 85479, 38149, 275, 308, 1371, 55719, 10952, 13, 34492,
            285, 30811, 1468, 285, 11, 9686, 11163, 281, 616, 21938, 593, 24768,
            25547, 11, 477, 5979, 99078, 285, 1153, 84, 486, 27439, 11, 70763, 5275,
            292, 5724, 27439, 82943, 15925, 80586, 13, 13182, 40027, 324, 1448, 287,
            6374, 10025, 355, 70763, 29413, 5724, 5275, 292, 5724, 11, 49580, 1343,
            548, 2221, 13535, 57996, 958, 67, 372, 13, 1322, 258, 64220, 18515, 285,
            72648, 13, 452, 1371, 264, 958, 67, 372, 90939, 13, 89008, 21938, 593,
            14464, 519, 4411, 8385, 490, 97496, 6252, 440, 355, 1880, 4272, 355, 1880,
            25000, 86200, 282, 986, 1645, 13535, 57996, 384, 7114, 300, 13, 42136,
            56455, 2536, 477, 5979, 1645, 10025, 355, 10732, 333, 408, 55509, 285,
            382, 44388, 21043, 15120, 38574, 68379, 96412, 16325, 17161, 9554, 17161,
            22656, 20379, 27452, 1811, 19000, 44388, 38574, 88435, 16325, 3922, 98739,
            74770, 52030, 28037, 16937, 42016, 9554, 21980, 231, 19113, 34208, 31944,
            28542, 39404, 18476, 3922, 11883, 37507, 82805, 17620, 6744, 235, 32648,
            19000, 55642, 16325, 17161, 13646, 9554, 21405, 47551, 1811, 13821, 234,
            4916, 249, 44388, 33764, 88126, 9554, 82805, 19361, 32938, 13821, 106,
            8239, 102, 3490, 28615, 3457, 653, 51173, 409, 69067, 665, 55467, 5019,
            38211, 15265, 78751, 324, 13, 7695, 687, 1188, 21797, 59570, 1880, 57705,
            31539, 71269, 83391, 42587, 5512, 7010, 1208, 96282, 93424, 13, 65381,
            9189, 409, 46131, 4068, 3900, 342, 12339, 27750, 33013, 98942, 25782,
            93311, 25657, 12561, 81448, 71995, 1506, 13373, 18600, 44155, 66144,
            12507, 46410, 9136, 4655, 53671, 13, 23784, 6850, 45122, 6578, 80595,
            8131, 21204, 39479, 91216, 44065, 18600, 44155, 80112, 1532, 14391, 67187,
            5591, 4655, 7740, 11122, 2156, 16248, 1840, 12561, 67124, 19479, 39280,
            13, 43896, 33793, 28647, 83680, 51627, 73385, 20440, 69556, 17165, 98117,
            47295, 11047, 15088, 9882, 9136, 58406, 1506, 382, 44090, 1560, 653, 58300,
            409, 33125, 665, 70988, 13, 763, 566, 56711, 90458, 390, 259, 699, 288,
            379, 60355, 43938, 33888, 2047, 3614, 1624, 41760, 7942, 70988, 13, 1717,
            248, 9697, 78, 3429, 5720, 19253, 55996, 53460, 5697, 924, 4037, 91689,
            45886, 49247, 382, 2028, 374, 459, 3187, 315, 1495, 304, 6498, 13, 1102,
            5764, 5410, 6498, 62603, 323, 4339, 17037, 1511, 304, 279, 4221, 13, 5560,
            433, 311, 6106, 701, 47058, 13777, 6498, 1495, 12722, 13
        ]
        let tokens = try await tokenizer.encode(text: text)
        XCTAssertEqual(expect, tokens)
    }
}
