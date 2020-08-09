import Foundation

protocol EarthquakesView: class {
   func updateView(with viewModel: EarthquakesViewModel)
}

final class EarthquakesPresenter {
    private unowned var view: EarthquakesView
    let service: (@escaping (Response<[Earthquake]>) -> ()) -> ()
    
    init(service: @escaping (@escaping (Response<[Earthquake]>) -> ()) -> (), view: EarthquakesView) {
        self.service = service
        self.view = view
    }
    
    func viewDidLoad() {
        view.updateView(with: EarthquakesViewModel.fetching())
        
        service({ [weak self] (response) in
            guard let self = self else { return }
            switch (response) {
            case .error(let error):
                DispatchQueue.main.async {
                    self.view.updateView(with: EarthquakesViewModel.failedFetching(error: self.prepareErrorToShow(error: error)))
                }
                return
            case .success(let earthquakes):
               DispatchQueue.main.async {
                 self.view.updateView(with: EarthquakesViewModel.successfullFetch(earthquakes: earthquakes.map(self.prepareEarthquakeToShow)))
               }
            }
        })
    }
    
    private func prepareEarthquakeToShow(earthquake: Earthquake) -> EarthquakeToShow {
        return EarthquakeToShow(country: earthquake.src,
                                date: earthquake.datetime,
                                magnitude: String(format: "%.1f", earthquake.magnitude),
                                isEarthquakeBig: earthquake.magnitude >= 8.0)
    }
    
    private func prepareErrorToShow(error: BackendError) -> String {
        switch error {
        case .noNetwork:
            return "No Internet connection. Please connect to the network"
        case .serverError:
            return "Server error. Please try later"
        case .clientError(let clientError):
            return clientError.message
        }
    }
}
