import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    static let shared = AuthViewModel()
    
    init() {
        userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    // Сделаем isValidEmail публичным
    public func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    public func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            print("DEBUG: Attempting to create user with email: \(email)")
            
            // Проверка входных данных
            guard !email.isEmpty, !password.isEmpty, !fullname.isEmpty else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Пожалуйста, заполните все поля"])
            }
            
            // Проверка формата email
            guard isValidEmail(email) else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Неверный формат email"])
            }
            
            // Проверка длины пароля
            guard password.count >= 6 else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Пароль должен содержать минимум 6 символов"])
            }
            
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            await fetchUser()
            
        } catch let error as NSError {
            print("DEBUG: Detailed error: \(error)")
            
            // Преобразование Firebase ошибок в понятные пользователю сообщения
            let message: String
            switch error.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                message = "Этот email уже используется. Попробуйте войти или используйте другой email."
            case AuthErrorCode.invalidEmail.rawValue:
                message = "Неверный формат email"
            case AuthErrorCode.weakPassword.rawValue:
                message = "Слишком слабый пароль. Используйте минимум 6 символов"
            default:
                message = error.localizedDescription
            }
            
            throw NSError(domain: "", code: error.code, userInfo: [NSLocalizedDescriptionKey: message])
        }
    }
    
    public func signIn(withEmail email: String, password: String) async throws {
        do {
            print("DEBUG: Attempting to sign in with email: \(email)")
            
            // Проверка входных данных
            guard !email.isEmpty, !password.isEmpty else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Пожалуйста, заполните все поля"])
            }
            
            // Проверка формата email
            guard isValidEmail(email) else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Неверный формат email"])
            }
            
            // Проверка длины пароля
            guard password.count >= 6 else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Пароль должен содержать минимум 6 символов"])
            }
            
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            
        } catch let error as NSError {
            print("DEBUG: Detailed sign in error: \(error)")
            
            // Преобразование Firebase ошибок в понятные пользователю сообщения
            let message: String
            switch error.code {
            case AuthErrorCode.wrongPassword.rawValue:
                message = "Неверный пароль"
            case AuthErrorCode.invalidEmail.rawValue:
                message = "Неверный формат email"
            case AuthErrorCode.userNotFound.rawValue:
                message = "Пользователь не найден"
            case AuthErrorCode.invalidCredential.rawValue:
                message = "Неверные учетные данные. Пожалуйста, проверьте email и пароль"
            case AuthErrorCode.networkError.rawValue:
                message = "Ошибка сети. Проверьте подключение к интернету"
            case AuthErrorCode.tooManyRequests.rawValue:
                message = "Слишком много попыток входа. Попробуйте позже"
            default:
                if error.localizedDescription.contains("malformed") || error.localizedDescription.contains("expired") {
                    message = "Срок действия сессии истек. Пожалуйста, войдите снова"
                } else {
                    message = "Ошибка входа. Пожалуйста, проверьте введенные данные"
                }
            }
            
            throw NSError(domain: "", code: error.code, userInfo: [NSLocalizedDescriptionKey: message])
        }
    }
    
    public func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    public func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            self.currentUser = try snapshot.data(as: User.self)
        } catch {
            print("DEBUG: Failed to fetch user with error \(error.localizedDescription)")
        }
    }
} 