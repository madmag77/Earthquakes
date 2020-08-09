import Foundation

import UIKit

final class EarthquakesViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var earthquakesList: UITableView!
    private lazy var presenter: EarthquakesPresenter = {
        return EarthquakesBuilder.build(view: self)
    } ()
    
    private var datasource: EarthquakesDatasource = EarthquakesDatasource(earthquakes: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        earthquakesList.delegate = self
        
        presenter.viewDidLoad()
    }
}

extension EarthquakesViewController: EarthquakesView {
    private func setNewDatasource(earthquakes: [EarthquakeToShow]) {
        datasource = EarthquakesDatasource(earthquakes: earthquakes)
        earthquakesList.dataSource = datasource
        earthquakesList.reloadData()
    }
    
    func updateView(with viewModel: EarthquakesViewModel) {
        activityIndicator.isHidden = viewModel.spinnerIsOn
        if let error = viewModel.error {
            errorLabel.isHidden = false
            errorLabel.text = error
        } else {
            errorLabel.isHidden = true
        }

        setNewDatasource(earthquakes: viewModel.earthquakes)
    }
}

extension EarthquakesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
