import Foundation
import MapKit
import UIKit

final class EarthquakeDetailsViewController: UIViewController {
    @IBOutlet private var mapView: MKMapView!
    
    var presenter: EarthquakeDetailsPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        navigationItem.backBarButtonItem?.title = "Back"
        
        presenter?.viewDidLoad()
    }
}

extension EarthquakeDetailsViewController: EarthquakeDetailsView {
    func updateView(with viewModel: EarthquakeDetailsViewmodel) {
        mapView.centerToLocation(CLLocation(latitude:viewModel.lat, longitude:  viewModel.lon))
        
        let mark = EarthquakeMark(
            title: viewModel.earthquakeDescription,
          coordinate: CLLocationCoordinate2D(latitude: viewModel.lat, longitude: viewModel.lon))
        mapView.addAnnotation(mark)
    }
}

extension EarthquakeDetailsViewController: MKMapViewDelegate {
    
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 100000) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
