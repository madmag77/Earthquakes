import XCTest
@testable import Earthquakes

class EarthquakesPresenterTests: XCTestCase {
    static private func getDateFromCompenents(year: Int,
                                              month: Int,
                                              day: Int,
                                              hour: Int,
                                              minute: Int,
                                              second: Int) -> Date {
        
        return Calendar.current.date(from: DateComponents(year: year,
                                                          month: month,
                                                          day: day,
                                                          hour: hour,
                                                          minute: minute,
                                                          second: second))!
    }
    
    fileprivate var earthquakes = [
        Earthquake(datetime: EarthquakesPresenterTests.getDateFromCompenents(year: 2020,
                                                                             month: 1,
                                                                             day: 15,
                                                                             hour: 12,
                                                                             minute: 1,
                                                                             second: 12),
                   depth: 1.0,
                   lng: 2.0,
                   src: "US",
                   eqid: "earthquake1",
                   magnitude: 4.0,
                   lat: 3.0),
        
        Earthquake(datetime: EarthquakesPresenterTests.getDateFromCompenents(year: 2020,
                                                                             month: 2,
                                                                             day: 16,
                                                                             hour: 12,
                                                                             minute: 1,
                                                                             second: 12),
                   depth: 10.0,
                   lng: 20.0,
                   src: "CA",
                   eqid: "earthquake2",
                   magnitude: 8.0,
                   lat: 30.0),
    ]
    
    var presenter: EarthquakesPresenter!
    var earthquakesFetchServiceMock: EarthquakesFetchServiceMock!
    var earthquakesViewMock: EarthquakesViewMock!
    
    override func setUpWithError() throws {
        earthquakesFetchServiceMock = EarthquakesFetchServiceMock()
        earthquakesViewMock = EarthquakesViewMock()
        
        presenter = EarthquakesPresenter(service: earthquakesFetchServiceMock.service(callback:), view: earthquakesViewMock)
    }
    
    override func tearDownWithError() throws {
        presenter = nil
        earthquakesViewMock = nil
        earthquakesFetchServiceMock = nil
    }
    
    func testDisplayProperEarthquakesNumber() throws {
        // Given
        earthquakesFetchServiceMock.responseToReturn = .success(earthquakes)
        
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertNotNil(earthquakesViewMock.lastViewModelApplied)
        XCTAssertFalse(earthquakesViewMock.lastViewModelApplied!.spinnerIsOn)
        XCTAssertEqual(earthquakesViewMock.lastViewModelApplied!.earthquakes.count, 2)
        XCTAssertNil(earthquakesViewMock.lastViewModelApplied!.error)
    }
    
    func testDisplayEarthquakeWithSmallMargnitude() throws {
        // Given
        earthquakesFetchServiceMock.responseToReturn = .success([earthquakes[0]])
        
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertNotNil(earthquakesViewMock.lastViewModelApplied)
        XCTAssertFalse(earthquakesViewMock.lastViewModelApplied!.earthquakes[0].isEarthquakeBig)
        XCTAssertEqual(earthquakesViewMock.lastViewModelApplied!.earthquakes[0].country, earthquakes[0].src)
        XCTAssertEqual(earthquakesViewMock.lastViewModelApplied!.earthquakes[0].date, "Jan 15, 2020")
    }
    
    func testDisplayEarthquakeWithBigMargnitude() throws {
        // Given
        earthquakesFetchServiceMock.responseToReturn = .success([earthquakes[1]])
        
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertNotNil(earthquakesViewMock.lastViewModelApplied)
        XCTAssertTrue(earthquakesViewMock.lastViewModelApplied!.earthquakes[0].isEarthquakeBig)
    }

    func testDisplayNoNetworkError() throws {
        // Given
        earthquakesFetchServiceMock.responseToReturn = .error(.noNetwork)
        
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertNotNil(earthquakesViewMock.lastViewModelApplied)
        XCTAssertFalse(earthquakesViewMock.lastViewModelApplied!.spinnerIsOn)
        XCTAssertNotNil(earthquakesViewMock.lastViewModelApplied!.error)
    }

    func testDisplayServerError() throws {
        // Given
        earthquakesFetchServiceMock.responseToReturn = .error(.serverError)
        
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertNotNil(earthquakesViewMock.lastViewModelApplied)
        XCTAssertFalse(earthquakesViewMock.lastViewModelApplied!.spinnerIsOn)
        XCTAssertNotNil(earthquakesViewMock.lastViewModelApplied!.error)
    }

    func testDisplayClienError() throws {
        // Given
        earthquakesFetchServiceMock.responseToReturn = .error(.clientError(.init(message: "message", value: 0)))
        
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertNotNil(earthquakesViewMock.lastViewModelApplied)
        XCTAssertFalse(earthquakesViewMock.lastViewModelApplied!.spinnerIsOn)
        XCTAssertNotNil(earthquakesViewMock.lastViewModelApplied!.error)
    }

}

class EarthquakesFetchServiceMock {
    func service(callback: (Response<[Earthquake]>) -> ()) {
        callback(responseToReturn!)
    }
    
    var responseToReturn: Response<[Earthquake]>?
}

class EarthquakesViewMock: EarthquakesView {
    var lastViewModelApplied: EarthquakesViewModel?
    
    func updateView(with viewModel: EarthquakesViewModel) {
        lastViewModelApplied = viewModel
    }
}


