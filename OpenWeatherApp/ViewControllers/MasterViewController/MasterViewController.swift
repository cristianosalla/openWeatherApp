import UIKit

struct WeatherObject: Codable {
    var cityName: String
    var weatherModel: WeatherModel
    var backgroundImageData: Data?
}

class MasterViewController: UIViewController {
    
    @IBOutlet var cardView: UIView?
    @IBOutlet var city: UILabel?
    @IBOutlet var descriptionLabel: UILabel?
    @IBOutlet var temperature: UILabel?
    
    @IBOutlet var image: UIImageView?
    @IBOutlet var backgroundImage: UIImageView?
    
    @IBOutlet var currentLocationButton: UIView?
    @IBOutlet var searchButton: UIView?
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView?
    
    let locationManager = LocationService()
    
    var cityList: [String] = [] {
        didSet {
            saveCityList()
        }
    }
    
    var weather: WeatherObject? {
        didSet {
            
            guard let weather = self.weather else {
                return
            }
            
            temperature?.text =  weather.weatherModel.temperatureCelsius()
            city?.text = weather.weatherModel.name
            descriptionLabel?.text = weather.weatherModel.weather.first?.weatherDescription ?? ""
            weather.weatherModel.image(completion: { image in
                DispatchQueue.main.async {
                    self.image?.image = image
                }
            })
            
            if let data = weather.backgroundImageData {
                self.backgroundImage?.image = UIImage(data: data)
            } else {
                self.backgroundImage?.image = UIImage(named: "neutra")
            }
            
            activityIndicator?.isHidden = true
            persistCity()
            persistCityList(name: weather.cityName)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cityList: [String] = LocalPersistenceService().loadData(key: .cityList) {
            self.cityList = cityList
        }
        
        locationManager.locationDelegate = self
        locationManager.retriveCurrentLocation()
        
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? SearchViewController
        vc?.searchResultDelegate = self
        vc?.cityList = self.cityList
        
    }
    
    internal func retrieveInformation(type: OpenWeatherServices.OpenWeatherType) {
        self.activityIndicator?.isHidden = false
        retrieveWeather(type: type) { name in
            self.retrieveBackgroundImage(name: name)
        }
    }
    
    private func setupUI() {
        guard let card = cardView, let locationButton = currentLocationButton, let searchButton = searchButton, let activityIndicator = activityIndicator else {
            return
        }
        
        card.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        card.layer.cornerRadius = card.frame.height/10
        
        locationButton.backgroundColor = UIColor.gray
        locationButton.layer.cornerRadius = locationButton.frame.height/10
        locationButton.layer.borderWidth = 1.0
        
        searchButton.backgroundColor = UIColor.gray
        searchButton.layer.cornerRadius = searchButton.frame.height/10
        searchButton.layer.borderWidth = 1.0
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    private func retrieveWeather(type: OpenWeatherServices.OpenWeatherType, completion: @escaping (String) -> Void) {
        let weatherService = OpenWeatherServices()
        
        switch type {
        case .city(let name):
            loadCity(name: name)
        default: break
        }
        
        weatherService.weather(type: type, completion: { [weak self] weather in
            DispatchQueue.main.async {
                if self?.weather?.cityName == weather.name {
                    self?.weather?.weatherModel = weather
                } else {
                    self?.weather = WeatherObject(cityName: weather.name, weatherModel: weather)
                }
                completion(weather.name)
            }
        }) { [weak self] error in
            DispatchQueue.main.async {
                self?.alert(alert: .init(error: error))
                self?.activityIndicator?.isHidden = true
            }
        }
    }
    
    private func retrieveBackgroundImage(name: String) {
        TeleportService().backgroundImage(citySearch: name) { data in
            DispatchQueue.main.async {
                self.weather?.backgroundImageData = data
            }
        }
    }
    
    private func saveCityList() {
        LocalPersistenceService().saveData(data: self.cityList, key: .cityList)
    }
    
    private func loadCity(name: String) {
        if let weather: WeatherObject = LocalPersistenceService().loadData(key: .city(name: name)) {
            self.weather = weather
        }
    }
    
    private func persistCity() {
        if let weather = self.weather {
            LocalPersistenceService().saveData(data: self.weather, key: .city(name: weather.cityName))
        }
    }
    
    private func persistCityList(name: String) {
        if !self.cityList.contains(name) {
            self.cityList.append(name)
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.activityIndicator?.isHidden = false
        locationManager.retriveCurrentLocation()
    }
}
