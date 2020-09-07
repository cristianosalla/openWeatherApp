
// MARK: - GeonameCity
struct GeonameCity: Codable {
    let links: Links
    
    enum CodingKeys: String, CodingKey {
        case links = "_links"
    }
}

// MARK: - Links
struct Links: Codable {
    let cityUrbanArea: City
    
    enum CodingKeys: String, CodingKey {
        case cityUrbanArea = "city:urban_area"
    }
}

// MARK: - City
struct City: Codable {
    let href: String
    let name: String
}
