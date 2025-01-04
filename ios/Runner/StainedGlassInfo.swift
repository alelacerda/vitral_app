import Foundation

struct StainedGlassInfo: Codable {
    let id: UUID = UUID()
    let title: String
    let description: String
    let category: Category
    let position: [Float]
    let imageUrl: String?
    let articleId: String?

    enum CodingKeys: String, CodingKey {
        case title, description, category, position, imageUrl, articleId
    }

    // Custom decoder to handle category as a string
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)

        // Decode category as a string and map it to a Category enum
        let categoryString = try container.decode(String.self, forKey: .category)
        guard let decodedCategory = Category(rawValue: categoryString) else {
            throw DecodingError.dataCorruptedError(forKey: .category, in: container, debugDescription: "Invalid category value")
        }
        category = decodedCategory

        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        articleId = try container.decodeIfPresent(String.self, forKey: .articleId)

        // Convert [Double] to [Float]
        let positionArray = try container.decode([Double].self, forKey: .position)
        position = positionArray.map { Float($0) }
    }
}
