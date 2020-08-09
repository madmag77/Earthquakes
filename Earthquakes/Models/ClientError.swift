import Foundation

struct ClientError: Codable, Equatable {
    let message: String
    let value: Int
}

struct ErrorResponse: Codable {
    let status: ClientError
}

