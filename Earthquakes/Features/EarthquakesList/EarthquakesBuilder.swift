import Foundation

struct EarthquakesBuilder {
    static func build(view: EarthquakesViewController) -> EarthquakesPresenter {
        let transport = RestTransportImpl()
        let getEarthquakesApi = getEarthquakes(transport: transport)
        
        // TODO: boundaries of the target area shouldn't be hardcoded (numbers are from the test request)
        return EarthquakesPresenter(
            service: { callback in getEarthquakesApi(44.1, -209.9, -22.4, 55.2, callback)},
            view: view)
    }
}
