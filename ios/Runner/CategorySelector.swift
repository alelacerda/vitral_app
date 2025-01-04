import SwiftUI

struct CategorySelector: View {
    
    @Binding var selectedCategory: Category?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 32) {
                ForEach(Category.allCases, id: \.self) { category in
                    CategoryButton(category: category, isSelected: category == selectedCategory) {
                        selectedCategory = category
                    }
                }
            }.padding(32)
        }.background(Color.white)
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
                    .font(isSelected ? Fonts.title1 : Fonts.title1Regular)
                
                if isSelected {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(category.color)
                        .frame(height: 4)
                }
            }
        }
    }
}

enum Category: String, CaseIterable, Codable {
    case funfacts = "funfact"
    case production = "production"
    case credits = "credits"
    case meaning = "meaning"

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
        case .funfacts: return .customOrange
        case .production: return .customPurple
        case .credits: return .customYellow
        case .meaning: return .lilac
        }
    }

    var fadedColor: Color {
        switch self {
        case .funfacts: return .orangeFaded
        case .production: return .purpleFaded
        case .credits: return .yellowFaded
        case .meaning: return .lilacFaded
        }
    }

    var titleColor: Color {
        switch self {
        case .funfacts, .production: return .white
        case .credits, .meaning: return .black
        }
    }
}

#Preview {
    @State var category: Category? = .funfacts
    CategorySelector(selectedCategory: $category)
}
