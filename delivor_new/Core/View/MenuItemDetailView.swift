import SwiftUI

struct MenuItemDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State var item: MenuItem
    let extras: [Extra]
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var selectedExtras: Set<Extra> = []
    @State private var quantity: Int = 1
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Заголовок
                    HStack {
                        Image(systemName: item.image)
                            .font(.largeTitle)
                            .foregroundColor(AppColors.accent)
                        
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.title2)
                                .foregroundColor(AppColors.textPrimary)
                            Text(item.description)
                                .font(.subheadline)
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                    .padding(.bottom)
                    
                    // Количество
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Количество")
                            .font(.headline)
                            .foregroundColor(AppColors.textPrimary)
                        
                        HStack {
                            Text("\(quantity) шт.")
                                .foregroundColor(AppColors.textPrimary)
                            Spacer()
                            Stepper("", value: $quantity, in: 1...10)
                                .labelsHidden()
                        }
                    }
                    
                    // Выбор лепешки и дополнений
                    Group {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(BreadType.allCases, id: \.self) { breadType in
                                BreadTypeButton(breadType: breadType, 
                                              isSelected: item.breadType == breadType) {
                                    item.breadType = breadType
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(extras) { extra in
                                ExtraItemButton(extra: extra,
                                              isSelected: selectedExtras.contains(extra)) {
                                    if selectedExtras.contains(extra) {
                                        selectedExtras.remove(extra)
                                    } else {
                                        selectedExtras.insert(extra)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .background(AppColors.background)
            
            // Кнопка добавления
            Button {
                cartViewModel.addToCart(
                    item: item,
                    quantity: quantity,
                    breadType: item.breadType,
                    extras: Array(selectedExtras)
                )
                dismiss()
            } label: {
                HStack {
                    Text("В корзину")
                        .fontWeight(.semibold)
                    Spacer()
                    Text("\(item.totalPrice * Double(quantity), specifier: "%.0f") ₽")
                        .fontWeight(.semibold)
                }
                .foregroundColor(AppColors.textPrimary)
                .padding()
                .background(AppColors.buttonGradient)
                .cornerRadius(12)
            }
            .padding()
        }
    }
}

struct BreadTypeButton: View {
    let breadType: BreadType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(AppColors.textPrimary)
                Text(breadType.rawValue)
                    .foregroundColor(AppColors.textPrimary)
                Spacer()
                if breadType.additionalPrice > 0 {
                    Text("+\(breadType.additionalPrice, specifier: "%.0f") ₽")
                        .foregroundColor(AppColors.textPrimary)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.buttonBackground(isSelected: isSelected))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColors.accent.opacity(0.3), lineWidth: isSelected ? 0 : 1)
                    )
            )
        }
    }
}

struct ExtraItemButton: View {
    let extra: Extra
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundColor(AppColors.textPrimary)
                Text(extra.name)
                    .foregroundColor(AppColors.textPrimary)
                Spacer()
                Text("+\(extra.price, specifier: "%.0f") ₽")
                    .foregroundColor(AppColors.textPrimary)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.buttonBackground(isSelected: isSelected))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColors.accent.opacity(0.3), lineWidth: isSelected ? 0 : 1)
                    )
            )
        }
    }
} 