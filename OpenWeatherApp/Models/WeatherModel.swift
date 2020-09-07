import Foundation
import UIKit

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let weather: [Weather]
    let main: Main
    let name: String
    
    func temperatureCelsius() -> String {
        
        let tempCelsius = self.main.temp - 273.15
        
        let formatedString = String(format: "%.2f", tempCelsius).celsiusString()
        
        return formatedString
    }
    
    func image(completion: @escaping (UIImage) -> Void) {
        
        guard let icon = self.weather.first?.icon else {
            return
        }
        
        let weatherService = OpenWeatherServices()
        weatherService.image(type: .image(string: icon), completion: { data in
            
            guard let image = UIImage(data: data) else {
                return
            }
            
            completion(image)
            
        })
        
    }
    
}

// MARK: - Main
struct Main: Codable {
    let temp: Double

    enum CodingKeys: String, CodingKey {
        case temp
    }
}

// MARK: - Weather
struct Weather: Codable {
    let weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case icon
    }
}
