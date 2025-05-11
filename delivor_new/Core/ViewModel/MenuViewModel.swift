import Foundation

class MenuViewModel: ObservableObject {
    @Published var menuItems: [MenuItem] = [
        MenuItem(name: "Классическая", description: "Курица, огурцы, помидоры, лук, соус", basePrice: 299, image: "fork.knife"),
        MenuItem(name: "Острая", description: "Курица, перец чили, огурцы, помидоры, соус", basePrice: 319, image: "flame.fill"),
        MenuItem(name: "Говяжья", description: "Говядина, огурцы, помидоры, лук, соус", basePrice: 349, image: "fork.knife.circle"),
        MenuItem(name: "Сырная", description: "Курица, сыр, огурцы, помидоры, соус", basePrice: 329, image: "circle.grid.cross"),
        MenuItem(name: "Вегетарианская", description: "Фалафель, огурцы, помидоры, лук, соус", basePrice: 279, image: "leaf.fill"),
        MenuItem(name: "Мексиканская", description: "Курица, халапеньо, кукуруза, соус", basePrice: 339, image: "sun.max.fill"),
        MenuItem(name: "Барбекю", description: "Курица, соус BBQ, лук, салат", basePrice: 329, image: "flame.circle.fill"),
        MenuItem(name: "Греческая", description: "Курица, салат, оливки, соус дзадзики", basePrice: 339, image: "star.fill"),
        MenuItem(name: "XXL", description: "Двойная порция мяса, все овощи, соус", basePrice: 399, image: "square.stack.3d.up.fill"),
        MenuItem(name: "Фирменная", description: "Секретный рецепт шефа", basePrice: 359, image: "crown.fill")
    ]
    
    let availableExtras: [Extra] = [
        Extra(name: "Сыр", price: 40),
        Extra(name: "Двойное мясо", price: 120),
        Extra(name: "Халапеньо", price: 30),
        Extra(name: "Картошка фри", price: 70)
    ]
} 