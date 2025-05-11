import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 24) {
            // Заголовок
            Text("Создать аккаунт")
                .font(.title)
                .foregroundColor(.white)
                .padding(.top, 32)
            
            // Поля ввода
            VStack(spacing: 20) {
                InputView(text: $email,
                         title: "Email",
                         placeholder: "name@example.com")
                    .textInputAutocapitalization(.never)
                
                InputView(text: $fullname,
                         title: "Полное имя",
                         placeholder: "Введите ваше имя")
                
                InputView(text: $password,
                         title: "Пароль",
                         placeholder: "Введите пароль",
                         isSecureField: true)
                
                InputView(text: $confirmPassword,
                         title: "Подтвердите пароль",
                         placeholder: "Подтвердите пароль",
                         isSecureField: true)
            }
            .padding(.horizontal)
            
            // Кнопка регистрации
            Button {
                Task {
                    do {
                        guard password == confirmPassword else {
                            errorMessage = "Пароли не совпадают"
                            showAlert = true
                            return
                        }
                        
                        try await viewModel.createUser(
                            withEmail: email,
                            password: password,
                            fullname: fullname
                        )
                    } catch {
                        errorMessage = error.localizedDescription
                        showAlert = true
                    }
                }
            } label: {
                Text("ЗАРЕГИСТРИРОВАТЬСЯ")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Кнопка входа
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Text("Уже есть аккаунт?")
                        .foregroundColor(.gray)
                    Text("Войти")
                        .foregroundColor(.yellow)
                }
                .font(.system(size: 14))
            }
            .padding(.bottom)
        }
        .background(Color.black)
        .alert("Ошибка", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}

// Добавим предварительный просмотр
#Preview {
    RegistrationView()
        .environmentObject(AuthViewModel.shared)
} 
