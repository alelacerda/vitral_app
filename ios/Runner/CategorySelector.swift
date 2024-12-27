import SwiftUI

struct CategorySelector: View {
    
    @State private var selectedCategory: Category = .funfacts
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 32) {
                ForEach(Category.allCases, id: \.self) { category in
                    CategoryButton(category: category, isSelected: category == selectedCategory) {
                        selectedCategory = category
                    }
                }
            }.padding(32)
        }
    }
}

struct CategoryButton: View {
    var category: Category
    var isSelected: Bool = true
    var onTap: () -> Void
    
    var body: some View {
        Button (action: onTap) {
            VStack(spacing: 4) {
                Text(category.title.uppercased())
                    .foregroundStyle(.black)
                
                if isSelected {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(category.color)
                        .frame(height: 4)
                }
            }
        }
    }
}

enum Category: CaseIterable {
    case funfacts, production, credits, meaning
    
    var title: String {
        switch self {
        case .funfacts: return "Curiosidades"
        case .production: return "Produção"
        case .credits: return "Créditos"
        case .meaning: return "Significados"
        }
    }
    
    var color: Color {
        switch self {
        case .funfacts: return .red
        case .production: return .purple
        case .credits: return .orange
        case .meaning: return .pink
        }
    }
}

#Preview {
    CategorySelector()
}
