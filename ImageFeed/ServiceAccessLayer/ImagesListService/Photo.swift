import UIKit

struct Photo {
    private static let formatter = ISO8601DateFormatter()
    
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
        createdAt = result.createdAt.flatMap { Photo.formatter.date(from: $0) }
        welcomeDescription = result.description
        thumbImageURL = result.urls.thumb
        largeImageURL = result.urls.full
        isLiked = result.likedByUser
    }
}
