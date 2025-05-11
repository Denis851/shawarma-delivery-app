import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text(viewModel.currentUser?.fullname ?? "")
                        Spacer()
                        Text(viewModel.currentUser?.email ?? "")
                            .foregroundColor(.gray)
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        viewModel.signOut()
                    } label: {
                        Text("Выйти")
                    }
                }
            }
            .navigationTitle("Профиль")
        }
    }
} 