
import Foundation
import UIKit

public enum ErrorType {
    case unknown
    case location
    case searchError
    case localStorage
    case request
}

struct AlertType {
    
    let title: String
    let message: String
    
    init(error: ErrorType) {
        switch error {
        case .unknown:
            self.title = "Erro desconhecido"
            self.message = "Tente novamente mais tarde."
        case .location:
            self.title = "Erro ao buscar localização"
            self.message = "Verifique se a localização está habilitada."
        case .searchError:
            self.title = "Nenhum resultado encontrado"
            self.message = "Não foi possível encontrar uma cidade com essa busca."
        case .localStorage:
            self.title = "Registro não encontrado"
            self.message = "Não encontramos esse dado no disco."
        case .request:
            self.title = "Não foi possível realizar essa ação"
            self.message = "Por favor, tente novamente mais tarde."
        }
    }
}

extension UIViewController {
    
    func alert(alert: AlertType) {
        let alert = UIAlertController(title: alert.title, message: alert.message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
