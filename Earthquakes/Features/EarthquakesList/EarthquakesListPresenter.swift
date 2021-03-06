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
                self.view.updateView(
                    with: EarthquakesViewModel.failedFetching(
                        error: self.prepareErrorToShow(error: error)
                    )
                )
                return
            case .success(let earthquakes):
                self.view.updateView(
                    with: EarthquakesViewModel.successfullFetch(
                        earthquakes: earthquakes.sorted(by: { (prev, next) -> Bool in
                            prev.datetime > next.datetime
                        }).map(self.prepareEarthquakeToShow)
                    )
                )
            }
        })
    }
    
    func prepareBuilerForEarthquakeDetailsModule(with earthquake: EarthquakeToShow) -> EarthquakeDetailsBuilder {
        return EarthquakeDetailsBuilder(earthquake: earthquake.rawModel)
    }
    
    private func prepareEarthquakeToShow(earthquake: Earthquake) -> EarthquakeToShow {
        return EarthquakeToShow(
            country: earthquake.src.uppercased(),
            date: DateFormatter.earthquakeDisplayDataFormatter.string(from: earthquake.datetime),
            magnitude: String(format: "%.1f", earthquake.magnitude),
            isEarthquakeBig: earthquake.magnitude >= 8.0,
            rawModel: earthquake
        )
    }
    
    private func prepareErrorToShow(error: BackendError) -> String {
        switch error {
        case .noNetwork:
            return "No Internet Connection."
        case .serverError:
            return "Server Error. Please try later"
        case .clientError(let clientError):
            return clientError.message
        }
    }
}
