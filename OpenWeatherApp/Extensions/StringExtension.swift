import Foundation

extension String {
    
    func celsiusString() -> String {
        return self.replacingOccurrences(of: ".", with: ",") + "º C"
    }
    
    func urlFormat() -> String {
         return self.folding(options: .diacriticInsensitive, locale: .current).replacingOccurrences(of: " ", with: "%20")
    }
}
