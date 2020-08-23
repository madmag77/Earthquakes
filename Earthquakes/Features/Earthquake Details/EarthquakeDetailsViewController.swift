import Foundation

import UIKit

final class EarthquakeDetailsViewController: UIViewController {
    var presenter: EarthquakeDetailsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
    }
    

}

extension EarthquakeDetailsViewController: EarthquakeDetailsView {
    func updateView(with viewModel: EarthquakeDetailsViewmodel) {
        
    }
}
