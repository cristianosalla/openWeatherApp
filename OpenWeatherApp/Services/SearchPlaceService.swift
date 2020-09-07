
import MapKit

class SearchPlaceService: NSObject, MKLocalSearchCompleterDelegate {
    
    func searchLocation(text: String, completion: @escaping ([Location]) -> (), errorHandler: @escaping (ErrorType) -> Void) {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            
            guard let mapItems = response?.mapItems else {
                errorHandler(.searchError)
                return
            }
            
            let results = mapItems.compactMap({ mapItem -> Location? in
                var coordinates: Location?
                let longitude = mapItem.placemark.coordinate.longitude.description
                let latitude = mapItem.placemark.coordinate.latitude.description
                
                if let name = mapItem.name {
                    coordinates = Location(name: name, latitude: latitude, longitude: longitude)
                }
                return coordinates
            })
            
            completion(results)
        }
    }
}
