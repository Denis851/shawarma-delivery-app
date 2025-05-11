import Foundation

class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []
    
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    func addToCart(item: MenuItem, quantity: Int, breadType: BreadType, extras: [Extra]) {
        let cartItem = CartItem(menuItem: item, quantity: quantity, selectedBreadType: breadType, selectedExtras: extras)
        cartItems.append(cartItem)
    }
    
    func removeItem(at index: Int) {
        cartItems.remove(at: index)
    }
    
    func clearCart() {
        cartItems.removeAll()
    }
    
    func updateQuantity(for item: CartItem, newQuantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            var updatedItem = item
            updatedItem.quantity = newQuantity
            cartItems[index] = updatedItem
        }
    }
} 