// MARK: - UrbanArea
struct UrbanArea: Codable {
    let photos: [Photo]
    
    enum CodingKeys: String, CodingKey {
        case photos
    }
}

// MARK: - Photo
struct Photo: Codable {
    let image: Image
}

// MARK: - Image
struct Image: Codable {
    let mobile: String
}
