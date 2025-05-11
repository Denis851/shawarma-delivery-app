import Foundation

struct CartItem: Identifiable {
    let id = UUID()
    let menuItem: MenuItem
    var quantity: Int
    var selectedBreadType: BreadType
    var selectedExtras: [Extra]
    
    var totalPrice: Double {
        let itemPrice = menuItem.basePrice + selectedBreadType.additionalPrice
        let extrasPrice = selectedExtras.reduce(0) { $0 + $1.price }
        return Double(quantity) * (itemPrice + extrasPrice)
    }
} 