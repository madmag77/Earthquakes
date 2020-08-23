import Foundation

protocol EarthquakeDetailsView: class {
    func updateView(with viewModel: EarthquakeDetailsViewmodel)
}

final class EarthquakeDetailsPresenter {
    private unowned var view: EarthquakeDetailsView
    private let earthquake: Earthquake
    
    init(view: EarthquakeDetailsView, earthquake: Earthquake) {
        self.view = view
        self.earthquake = earthquake
    }
    
    func viewDidLoad() {
        view.updateView(with: EarthquakeDetailsViewmodel(lat: earthquake.lat, lon: earthquake.lng, earthquakeDescription: "Earthquake"))
    }
}
