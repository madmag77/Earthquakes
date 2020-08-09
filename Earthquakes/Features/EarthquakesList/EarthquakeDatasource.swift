import UIKit

// Very akward Objc legacy - I'd be happy to have it as a struct
final class EarthquakesDatasource: NSObject {
    let earthquakes: [EarthquakeToShow]
    
    init(earthquakes: [EarthquakeToShow]) {
        self.earthquakes = earthquakes
        super.init()
    }
}

extension EarthquakesDatasource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return earthquakes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EarthquakeListCellView.reusableIdentifier) as? EarthquakeListCellView else { fatalError() }
        
        cell.updateWithViewmodel(earthquake: earthquakes[indexPath.row])

        return cell
    }
}
