import Foundation

struct StainedGlassInfo: Codable {
    let title: String
    let description: String
    let category: String
    let position: [Float]
    let imageUrl: String?
    let articleId: String?
    
    init(
        title: String,
        description: String,
        category: String,
        position: [Float],
        imageUrl: String? = nil,
        articleId: String? = nil
    ) {
        self.title = title
        self.description = description
        self.category = category
        self.position = position
        self.imageUrl = imageUrl
        self.articleId = articleId
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "description": description,
            "category": category,
            "position": position,
            "imageUrl": imageUrl as Any,
            "articleId": articleId as Any
        ]
    }
    
    static func fromDictionary(_ dictionary: [String: Any]) -> StainedGlassInfo? {
        guard
            let title = dictionary["title"] as? String,
            let description = dictionary["description"] as? String,
            let category = dictionary["category"] as? String,
            let position = dictionary["position"] as? [Float]
        else {
            return nil
        }
        
        let imageUrl = dictionary["imageUrl"] as? String
        let articleId = dictionary["articleId"] as? String
        
        return StainedGlassInfo(
            title: title,
            description: description,
            category: category,
            position: position,
            imageUrl: imageUrl,
            articleId: articleId
        )
    }
}
