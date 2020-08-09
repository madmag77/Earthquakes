import UIKit

final class EarthquakeListCellView: UITableViewCell {
    static let reusableIdentifier = "EarthquakeListCellView"
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var magnitudeLabel: UILabel!
    
    func updateWithViewmodel(earthquake: EarthquakeToShow) {
        dateLabel.text = earthquake.date
        countryLabel.text = earthquake.country
        magnitudeLabel.text = earthquake.magnitude
        
        if earthquake.isEarthquakeBig {
            magnitudeLabel.textColor = UIColor.red
            magnitudeLabel.font = magnitudeLabel.font.withSize(21)
        } else {
            magnitudeLabel.textColor = UIColor.black
            magnitudeLabel.font = magnitudeLabel.font.withSize(18)
        }
    }
}
