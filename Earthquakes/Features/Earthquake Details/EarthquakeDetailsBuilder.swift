import Foundation

struct EarthquakeDetailsBuilder {
    private let earthquake: Earthquake
    init(earthquake: Earthquake) {
        self.earthquake = earthquake
    }
    
    func build(view: EarthquakeDetailsViewController) {
        let presenter = EarthquakeDetailsPresenter(view: view, earthquake: earthquake)
        view.presenter = presenter
    }
}
