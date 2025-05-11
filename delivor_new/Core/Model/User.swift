import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
} 