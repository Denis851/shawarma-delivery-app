import SwiftUI

struct HomeView: View {
    @StateObject private var menuViewModel = MenuViewModel()
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var selectedItem: MenuItem?
    @State private var showingDetail = false
    let hotlineNumber = "+7 \(Int.random(in: 900...999)) \(Int.random(in: 100...999)) \(Int.random(in: 10...99)) \(Int.random(in: 10...99))"
    @State private var showingHotlineTooltip = false
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: 
                    HStack {
                        Text("Горячая линия")
                            .foregroundColor(.red)
                        Image(systemName: "info.circle")
                            .foregroundColor(.gray)
                            .onTapGesture {
                                showingHotlineTooltip = true
                            }
                    }
                ) {
                    HStack {
                        Text(hotlineNumber)
                            .foregroundColor(.white)
                        Spacer()
                        Button(action: {
                            UIPasteboard.general.string = hotlineNumber
                            withAnimation {
                                let generator = UINotificationFeedbackGenerator()
                                generator.notificationOccurred(.success)
                            }
                        }) {
                            Label("Копировать", systemImage: "doc.on.doc")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.borderless)
                    }
                }
                
                ForEach(menuViewModel.menuItems) { item in
                    MenuItemRow(item: item)
                        .listRowBackground(AppColors.cardBackground)
                        .onTapGesture {
                            selectedItem = item
                            showingDetail = true
                        }
                        .buttonStyle(ScaleButtonStyle())
                }
            }
            .listStyle(.plain)
            .background(AppColors.background)
            .navigationTitle("Меню")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(AppColors.mainBlack, for: .navigationBar)
            .sheet(isPresented: $showingDetail) {
                if let item = selectedItem {
                    MenuItemDetailView(item: item, extras: menuViewModel.availableExtras)
                        .environmentObject(cartViewModel)
                }
            }
            .alert("Горячая линия", isPresented: $showingHotlineTooltip) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Позвоните нам, если у вас возникли вопросы или проблемы с заказом")
            }
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct MenuItemRow: View {
    let item: MenuItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 1)
                
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .opacity(0.9)
                    .lineLimit(1)
                
                Text("\(item.basePrice, specifier: "%.0f") ₽")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
                    .shadow(radius: 1)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white)
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
