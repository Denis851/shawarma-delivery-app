import Foundation

struct MenuItem: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let basePrice: Double
    let image: String
    var breadType: BreadType = .classic
    var extras: [Extra] = []
    
    var totalPrice: Double {
        let breadPrice = breadType.additionalPrice
        let extrasPrice = extras.reduce(0) { $0 + $1.price }
        return basePrice + breadPrice + extrasPrice
    }
}

enum BreadType: String, CaseIterable {
    case classic = "Классическая"
    case cheese = "Сырная"
    case baton = "Батон"
    
    var additionalPrice: Double {
        switch self {
        case .classic: return 0
        case .cheese: return 30
        case .baton: return 20
        }
    }
}

struct Extra: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let price: Double
    
    // Реализация Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Extra, rhs: Extra) -> Bool {
        lhs.id == rhs.id
    }
} 