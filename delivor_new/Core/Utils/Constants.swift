import SwiftUI

struct AppColors {
    // Основные цвета
    static let accent = Color.black
    static let secondary = Color.black
    static let background = Color.black
    static let mainBlack = Color.black
    static let cardBackground = Color.black.opacity(0.6)
    
    // Текстовые цвета
    static let textPrimary = Color.white
    static let textSecondary = Color.black
    
    // Градиенты
    private static let Colors = [Color.black]
    private static let buttonColors = [Color.red, Color.yellow]
    
    static let mainGradient = LinearGradient(
        gradient: Gradient(colors: Colors),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let mainGradientReversed = LinearGradient(
        gradient: Gradient(colors: Colors.reversed()),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let buttonGradient = LinearGradient(
        gradient: Gradient(colors: buttonColors),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static func buttonBackground(isSelected: Bool) -> AnyShapeStyle {
        if isSelected {
            return AnyShapeStyle(buttonGradient)
        } else {
            return AnyShapeStyle(Color.clear)
        }
    }
} 
