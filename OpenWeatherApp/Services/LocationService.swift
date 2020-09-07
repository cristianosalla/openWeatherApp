import CoreLocation

struct Location {
    var name: String?
    var latitude: String
    var longitude: String
}

protocol LocationProtocol: class {
    func currentLocation(_ location: Location)
    func locationError(_ error: ErrorType)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    private let locationManager: CLLocationManager
    
    weak var locationDelegate: LocationProtocol?
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }
    
    func requestUserLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func retriveCurrentLocation() {
        let status = CLLocationManager.authorizationStatus()

        if(status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled()){
            locationDelegate?.locationError(.location)
            return
        }

        if(status == .notDetermined){
            locationManager.requestWhenInUseAuthorization()
            locationDelegate?.locationError(.location)
            return
        }
        
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationDelegate?.locationError(.location)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        let longitude = userLocation.coordinate.longitude.description
        let latitude = userLocation.coordinate.latitude.description
        
        locationDelegate?.currentLocation(Location(latitude: latitude, longitude: longitude))
    }
}
