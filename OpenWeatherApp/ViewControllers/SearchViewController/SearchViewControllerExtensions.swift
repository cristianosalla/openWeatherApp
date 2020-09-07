import UIKit

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = dataSource[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            
           self.searchResultDelegate?.search(self.dataSource[indexPath.row])
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.activityIndicator?.isHidden = false
        searchPlace.searchLocation(text: searchBar.text ?? "", completion: { [weak self] response in
            DispatchQueue.main.async {
                self?.dataSource = response
                self?.activityIndicator?.isHidden = true
            }
        }) { [weak self] error in
            DispatchQueue.main.async {
                self?.alert(alert: .init(error: error))
                self?.activityIndicator?.isHidden = true
            }
        }
    }
}
