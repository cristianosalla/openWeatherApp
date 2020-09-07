
import Foundation
import UIKit

protocol SearchResultProtocol: class {
    func search(_ location: Location)
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var searchBar: UISearchBar?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    weak var searchResultDelegate: SearchResultProtocol?

    var cityList: [String] = []
    
    let searchPlace = SearchPlaceService()
    
    var dataSource: [Location] = [] {
        didSet {
            self.tableView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !self.cityList.isEmpty {
            dataSource = self.cityList.map({ name -> Location in
                let location = Location(name: name, latitude: "", longitude: "")
                
                return location
            })
        }
        
        self.activityIndicator?.isHidden = true
        self.activityIndicator?.startAnimating()

        tableView?.dataSource = self
        tableView?.delegate = self
        searchBar?.delegate = self
    }
}
