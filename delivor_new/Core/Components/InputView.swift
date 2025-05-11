import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.white)
                .font(.headline)
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(.plain)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .textContentType(.password)
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(.plain)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.red.opacity(0.3))
        }
    }
}

// Добавим предварительный просмотр
#Preview {
    InputView(text: .constant(""), title: "Email", placeholder: "name@example.com")
        .padding()
        .background(Color.black)
} 