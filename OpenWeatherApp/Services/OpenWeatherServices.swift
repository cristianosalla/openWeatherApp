
import Foundation
import UIKit

class OpenWeatherServices: RequestService {
    
    public enum OpenWeatherType {
        case city(name: String)
        case coordinates(lat: String, lon: String)
        case image(string: String)
        
        internal func endpoint(search: OpenWeatherType) -> String {
            var urlString = "http://api.openweathermap.org/data/2.5/weather?"
            
            switch search {
                
            case .city(let name):
                let nameString = name.urlFormat()
                    
                urlString.append("q=\(nameString)")
                
            case .coordinates(let lat, let lon):
                urlString.append("lat=\(lat)&lon=\(lon)")
                
            case .image(let string):
                var urlString = "https://openweathermap.org/img/wn/"
                
                urlString.append("\(string)@2x.png")
                
                return urlString
                
            }
            
            urlString.append("&lang=pt_br&appid=88478d1a69e1f2aadcb4f25dba22aa95")
            
            return urlString
        }
    }
    
    func image(type: OpenWeatherType, completion: @escaping (Data) -> Void) {
        
        self.requestData(type: Data.self, urlString: type.endpoint(search: type)) { (data) in
            completion(data)
        }
    }
    
    func weather(type: OpenWeatherType, completion: @escaping (WeatherModel) -> Void, errorHandler: @escaping (ErrorType) -> Void) {
        
        self.requestData(type: WeatherModel.self, urlString: type.endpoint(search: type), completion: { data in
            completion(data)
        })
        
    }
}


