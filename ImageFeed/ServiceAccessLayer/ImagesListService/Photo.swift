import UIKit

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

extension Photo {
    init(from result: PhotoResult) {
        id = result.id
        size = CGSize(width: result.width, height: result.height)
        
        let formatter = ISO8601DateFormatter()
        createdAt = result.createdAt.flatMap {
            formatter.date(from: $0)
        }
        
        welcomeDescription = result.description
        thumbImageURL = result.urls.thumb
        largeImageURL = result.urls.full
        isLiked = result.likedByUser
    }
}
