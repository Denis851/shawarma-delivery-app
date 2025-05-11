import SwiftUI

struct PromotionsView: View {
    @State private var isAnimating = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Image(systemName: "tag.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: isAnimating)
                
                VStack(spacing: 15) {
                    Text("Скоро здесь будут акции")
                        .font(.title)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Следите за обновлениями")
                        .foregroundColor(.gray)
                }
                
                // Примеры будущих акций
                VStack(alignment: .leading, spacing: 20) {
                    PromoPreviewRow(title: "2 по цене 1", description: "Скоро")
                    PromoPreviewRow(title: "Счастливые часы", description: "Скоро")
                    PromoPreviewRow(title: "Студенческая скидка", description: "Скоро")
                }
                .padding()
                .background(AppColors.cardBackground)
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.background)
            .navigationTitle("Акции")
            .onAppear {
                isAnimating = true
            }
        }
    }
}

struct PromoPreviewRow: View {
    let title: String
    let description: String
    
    var body: some View {
        HStack {
            Image(systemName: "clock.fill")
                .foregroundColor(.red)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(AppColors.textPrimary)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
    }
} 