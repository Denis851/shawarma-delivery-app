import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var showingOrderConfirmation = false
    @State private var showingHelpTip = false
    
    var body: some View {
        NavigationStack {
            if cartViewModel.cartItems.isEmpty {
                EmptyCartView()
            } else {
                List {
                    Section(header:
                        HStack {
                            Text("Подсказка")
                                .foregroundColor(.gray)
                            Spacer()
                            Button {
                                showingHelpTip = true
                            } label: {
                                Image(systemName: "questionmark.circle")
                                    .foregroundColor(.gray)
                            }
                        }
                    ) {
                        Text("Смахните карточку влево для удаления")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    ForEach(cartViewModel.cartItems) { item in
                        CartItemRow(item: item, cartViewModel: cartViewModel)
                            .transition(.slide)
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { cartViewModel.removeItem(at: $0) }
                    }
                    
                    Section {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Итого:")
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(cartViewModel.totalPrice, specifier: "%.0f") ₽")
                                    .foregroundColor(.yellow)
                                    .bold()
                            }
                            
                            Button(action: {
                                showingOrderConfirmation = true
                            }) {
                                Text("Оформить заказ")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(AppColors.buttonGradient)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .background(AppColors.mainGradient)
                .navigationTitle("Корзина")
                .toolbar {
                    Button("Очистить") {
                        withAnimation {
                            cartViewModel.clearCart()
                        }
                    }
                    .foregroundColor(.red)
                }
                .alert("Подтверждение заказа", isPresented: $showingOrderConfirmation) {
                    Button("Отмена", role: .cancel) { }
                    Button("Подтвердить") {
                        // Здесь будет логика оформления заказа
                        cartViewModel.clearCart()
                    }
                } message: {
                    Text("Сумма заказа: \(cartViewModel.totalPrice, specifier: "%.0f") ₽\nПодтвердить оформление?")
                }
                .alert("Подсказка", isPresented: $showingHelpTip) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("• Смахните товар влево для удаления\n• Используйте + и - для изменения количества\n• Нажмите 'Очистить' для удаления всех товаров")
                }
            }
        }
    }
}

struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundColor(.red)
            Text("Корзина пуста")
                .font(.title)
                .foregroundColor(.white)
            Text("Добавьте что-нибудь из меню")
                .foregroundColor(.gray)
        }
    }
}

struct CartItemRow: View {
    let item: CartItem
    @ObservedObject var cartViewModel: CartViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.menuItem.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 1)
                
                Spacer()
                
                Text("\(item.totalPrice, specifier: "%.0f") ₽")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .shadow(radius: 1)
            }
            
            Text("\(item.quantity) шт. • \(item.selectedBreadType.rawValue)")
                .font(.subheadline)
                .foregroundColor(.white)
                .opacity(0.9)
            
            if !item.selectedExtras.isEmpty {
                Text(item.selectedExtras.map { $0.name }.joined(separator: " • "))
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .opacity(0.9)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.buttonGradient)
        )
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
} 