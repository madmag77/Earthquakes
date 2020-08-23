import Foundation

struct EarthquakesViewModel {
    let error: String?
    let spinnerIsOn: Bool
    let earthquakes: [EarthquakeToShow]
    
    static func initState() -> EarthquakesViewModel {
        return EarthquakesViewModel(
        error: nil,
        spinnerIsOn: false,
        earthquakes: [])
    }
    
    static func successfullFetch(earthquakes: [EarthquakeToShow]) -> EarthquakesViewModel {
        return EarthquakesViewModel(
        error: nil,
        spinnerIsOn: false,
        earthquakes: earthquakes)
    }
    
    static func fetching() -> EarthquakesViewModel {
        return EarthquakesViewModel(
        error: nil,
        spinnerIsOn: true,
        earthquakes: [])
    }
    
    static func failedFetching(error: String) -> EarthquakesViewModel {
        return EarthquakesViewModel(
        error: error,
        spinnerIsOn: false,
        earthquakes: [])
    }
}

struct EarthquakeToShow {
    let country: String
    let date: String
    let magnitude: String
    let isEarthquakeBig: Bool
    
    let rawModel: Earthquake
}
