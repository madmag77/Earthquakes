import Foundation

protocol RestTransport {
func get<S: Decodable, D>(endpoint: String, parameters: [String: Any], transform: @escaping (S)->(D), callback: @escaping (Response<D>) -> ())
}

struct RestTransportImpl: RestTransport {
    private let baseUrl = "http://api.geonames.org/"
    
    // TODO: This shouldn't be hardcoded obviously
    private let username = "mkoppelman"
    
    // TODO: better to inject in order to test this struct
    private let session = URLSession.shared
    
    /// S - source network entity, D - destination/required domain entity
    func get<S: Decodable, D>(endpoint: String, parameters: [String: Any], transform: @escaping (S)->(D), callback: @escaping (Response<D>) -> ()) {
        
        var components = URLComponents(string: baseUrl + endpoint)!
        
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: "\(value)")
        }
        
        components.queryItems?.append(URLQueryItem(name: "username", value: username))
        
        var request = URLRequest(url: components.url!)

        request.httpMethod = "GET"
         
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       
        session.dataTask(with: request, completionHandler: { data, response, error in

            if error != nil || data == nil {
                callback(.error(.noNetwork))
                return
            }

            guard let response = response as? HTTPURLResponse,
                let mime = response.mimeType,
                mime == "application/json",
                let body = data,
                response.statusCode < 500
            else {
                 callback(.error(.serverError))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
            
            let errorHandler: (Data) -> () = { body in
                do {
                    let error = try decoder.decode(ErrorResponse.self, from: body)
                    callback(.error(.clientError(error.status)))
                } catch {
                    callback(.error(.serverError))
                }
            }
            
            switch response.statusCode {
                case 200..<300:
                   do {
                        let res = try decoder.decode(S.self, from: body)
                        callback(.success(transform(res)))
                   } catch {
                        errorHandler(body)
                   }
                   return
               case 400..<500:
                   errorHandler(body)
                   return
               default:
                    // Fail fast
                   fatalError("Shouldn't be such an error code")
            }
        }).resume()
    }
}

extension DateFormatter {
  static let iso8601Full: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}
