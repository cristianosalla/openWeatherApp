
import Foundation

enum DefaultsKeys {
    case city(name: String)
    case cityList
    
    var key: String {
        switch self {
        case .city(let name):
            return "\(name)"
        case .cityList:
            return "cityList"
        }
    }
}

class LocalPersistenceService {
    
    func saveData<T: Encodable>(data: T, key: DefaultsKeys) {
        let defaults = UserDefaults.standard
        let encodedData: Data? = try? JSONEncoder().encode(data)
        defaults.set(encodedData, forKey: key.key)
        defaults.synchronize()
    }
    
    func loadData<T: Codable>(key: DefaultsKeys) -> T? {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: key.key) {
            let dataObject = try? JSONDecoder().decode(T.self, from: data)
            return dataObject
        }
        return nil
    }
}
