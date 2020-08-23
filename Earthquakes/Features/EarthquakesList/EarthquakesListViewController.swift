import Foundation

import UIKit

final class EarthquakesViewController: UIViewController {
    private let errorViewHeight: CGFloat = 30.0
    private let earthquakeDetailsSegueIdentifier = "showEarthquakeDetails"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var earthquakesList: UITableView!
    @IBOutlet weak var errorViewHeightConstraint: NSLayoutConstraint!
    private lazy var presenter: EarthquakesPresenter = {
        return EarthquakesBuilder.build(view: self)
    } ()
    
    private var datasource: EarthquakesDatasource = EarthquakesDatasource(earthquakes: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        earthquakesList.delegate = self
        
        presenter.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
            identifier == earthquakeDetailsSegueIdentifier,
            let earthquake = sender as? EarthquakeToShow,
            let detailsVC = segue.destination as? EarthquakeDetailsViewController
        else { return }
        
        presenter.prepareBuilerForEarthquakeDetailsModule(with: earthquake).build(view: detailsVC)
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
            errorViewHeightConstraint.constant = errorViewHeight
        } else {
            errorLabel.isHidden = true
            errorViewHeightConstraint.constant = 0
        }

        setNewDatasource(earthquakes: viewModel.earthquakes)
    }
}

extension EarthquakesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: earthquakeDetailsSegueIdentifier, sender: datasource.earthquakes[indexPath.row])
    }
}
