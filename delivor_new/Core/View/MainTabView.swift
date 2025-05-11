import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject private var cartViewModel = CartViewModel()
    
    var body: some View {
        if viewModel.userSession == nil {
            LoginView()
        } else {
            TabView {
                HomeView()
                    .environmentObject(cartViewModel)
                    .tabItem {
                        Label("Меню", systemImage: "fork.knife")
                    }
                
                CartView()
                    .environmentObject(cartViewModel)
                    .tabItem {
                        Label("Корзина", systemImage: "cart")
                    }
                
                PromotionsView()
                    .tabItem {
                        Label("Акции", systemImage: "tag")
                    }
                
                ProfileView()
                    .tabItem {
                        Label("Профиль", systemImage: "person")
                    }
            }
            .accentColor(.red)
        }
    }
} 