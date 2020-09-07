
import Foundation

class TeleportService: RequestService {
    
    struct TeleportEndpoint {
        let endpoint = "https://api.teleport.org/api/"
        let cities = "cities/"
        let urbanArea = "urban_areas/"
        
        func searchUrl(text: String) -> String {
            let search = "?search="
            return endpoint + cities + search + text.urlFormat()
        }
        
        func urbanAreaImage(url: String) -> String {
            
            let images = "images"
            
            return url + images
        }
        
    }
    
    let endpoint = TeleportEndpoint()
    
    func backgroundImage(citySearch: String, completion: @escaping (Data) -> Void) {
        let urlString = endpoint.searchUrl(text: citySearch)
        
        requestData(type: TeleportCity.self, urlString: urlString) { data in
            if let geonameUrl = data.embedded.citySearchResults.first?.links.cityItem.href {
                
                self.requestData(type: GeonameCity.self, urlString: geonameUrl) { data in
                    
                    let urbanAreaUrl = data.links.cityUrbanArea.href
                    let imageUrl = self.endpoint.urbanAreaImage(url: urbanAreaUrl)
                    
                    self.requestData(type: UrbanArea.self, urlString: imageUrl) { (urbanArea) in
                        if let imageData = urbanArea.photos.first?.image.mobile {
                            
                            self.requestData(type: Data.self, urlString: imageData) { (data) in
                                
                                completion(data)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
}
