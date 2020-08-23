import Foundation


// TODO: implement paging as now it doesn't make sense to do it for 10 items
func getEarthquakes(transport: RestTransport) -> (Double, Double, Double, Double, @escaping (Response<[Earthquake]>) -> ()) -> () {
    return { north, south, east, west, callback in
            transport.get(endpoint: "earthquakesJSON",
                          parameters: [
                            "north": north,
                            "south": south,
                            "east": east,
                            "west": west],
                          transform: { (earthquakesResponse: EarthquakesResponse) in
                            earthquakesResponse.earthquakes },
                          callback: { response in DispatchQueue.main.async { callback(response) } } )
        }
}
