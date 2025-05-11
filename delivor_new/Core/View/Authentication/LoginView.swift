import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                // Логотип
                Text("Delivor")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 32)
                
                // Поля ввода
                VStack(spacing: 24) {
                    InputView(text: $email,
                            title: "Email",
                            placeholder: "name@example.com")
                        .textInputAutocapitalization(.never)
                    
                    InputView(text: $password,
                            title: "Пароль",
                            placeholder: "Введите пароль",
                            isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // Кнопка входа
                Button {
                    Task {
                        do {
                            try await viewModel.signIn(withEmail: email, password: password)
                        } catch {
                            errorMessage = error.localizedDescription
                            showAlert = true
                        }
                    }
                } label: {
                    HStack {
                        Text("ВОЙТИ")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                // Кнопка регистрации
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack(spacing: 3) {
                        Text("Нет аккаунта?")
                        Text("Зарегистрироваться")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
            }
        }
        .alert("Ошибка", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
} 