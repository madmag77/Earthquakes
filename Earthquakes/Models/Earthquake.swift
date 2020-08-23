import Foundation

struct Earthquake: Codable, Equatable {
    let datetime: Date
    let depth: Double
    let lng: Double
    let src: String
    let eqid: String
    let magnitude: Double
    let lat: Double
}

struct EarthquakesResponse: Codable {
    let earthquakes: [Earthquake]
}
