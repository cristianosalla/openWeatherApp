
import Foundation

class RequestService {
    
    // MARK: - Data Only
    func requestData<T: Codable>(type: T.Type, urlString: String, completion: @escaping (T) -> Void) {
    
        guard let urlString = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: urlString)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(T.self, from: data) {
                    completion(decodedResponse)
                }
                
                if type == Data.self, let data = data as? T {
                    completion(data)
                }
            }
            
        }.resume()
    }
    
    // MARK: - Error Handler
    func requestData<T: Codable>(type: T.Type, urlString: String, completion: @escaping (T) -> Void, errorHandler: @escaping (ErrorType) -> Void) {
        guard let urlString = URL(string: urlString) else {
            errorHandler(.localStorage)
            return
        }
        
        let request = URLRequest(url: urlString)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(T.self, from: data) {
                    completion(decodedResponse)
                } else if type == Data.self, let data = data as? T {
                    completion(data)
                } else {
                    errorHandler(.localStorage)
                }
            } else {
                errorHandler(.localStorage)
            }
        }.resume()
    }
    
}
