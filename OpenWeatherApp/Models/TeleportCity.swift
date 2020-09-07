// MARK: - TeleportCity
struct TeleportCity: Codable {
    let embedded: Embedded
    
    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
}

// MARK: - Embedded
struct Embedded: Codable {
    let citySearchResults: [CitySearchResult]
    
    enum CodingKeys: String, CodingKey {
        case citySearchResults = "city:search-results"
    }
}

// MARK: - CitySearchResult
struct CitySearchResult: Codable {
    let links: CitySearchResultLinks
    
    enum CodingKeys: String, CodingKey {
        case links = "_links"
    }
}

// MARK: - CitySearchResultLinks
struct CitySearchResultLinks: Codable {
    let cityItem: SelfClass
    
    enum CodingKeys: String, CodingKey {
        case cityItem = "city:item"
    }
}

// MARK: - SelfClass
struct SelfClass: Codable {
    let href: String
}
