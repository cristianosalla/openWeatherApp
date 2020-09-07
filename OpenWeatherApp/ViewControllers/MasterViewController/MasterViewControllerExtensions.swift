import UIKit

extension MasterViewController: SearchResultProtocol {
    
    func search(_ location: Location) {
        guard let name = location.name else {
            return
        }
        
        retrieveInformation(type: .city(name: name))
    }
}

extension MasterViewController: LocationProtocol {
    
    func locationError(_ error: ErrorType) {
        self.alert(alert: .init(error: error))
    }
    
    func currentLocation(_ location: Location) {
        retrieveInformation(type:
            .coordinates(lat: location.latitude,
                         lon: location.longitude))
    }
}
