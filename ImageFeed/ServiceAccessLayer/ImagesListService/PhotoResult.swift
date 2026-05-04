struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
    
    struct UrlsResult: Decodable {
        let thumb: String
        let full: String
    }
}
