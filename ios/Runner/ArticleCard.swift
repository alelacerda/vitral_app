import SwiftUI

struct ArticleCard: View {
    var category: Category
    var article: String?
    var articleTitle: String
    var articleImage: String?
    var articleDescription: String
    var currentArticleIndex: Int = 0
    var numberOfArticles: Int
    
    var body: some View {
        
        VStack {
            HStack(alignment: .bottom) {
                Text(category.title.uppercased())
                    .font(Fonts.title1)
                    .foregroundStyle(category.titleColor)
                    .padding(12)
                    .background(category.color)
                    .cornerRadius(16)
                Spacer()
                if article != nil {
                    Button(action: {}) {
                        Text(" Ler artigo ")
                            .font(Fonts.title2)
                            .foregroundStyle(.black)
                            .padding(8)
                            .background(.lilacFaded)
                            .cornerRadius(16)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(articleTitle)
                    .font(Fonts.title2)
                    .foregroundStyle(.black)
                    .padding(.bottom, 8)
                
                HStack {
                    if let image = articleImage {
                        Image(image)
                    }
                    
                    Text(articleDescription)
                        .multilineTextAlignment(.leading)
                        .font(Fonts.body)
                        .foregroundStyle(.black)
                }
                
                HStack {
                    Spacer()
                    ArticleIndicator(currentIndicator: currentArticleIndex,
                                     totalIndicators: numberOfArticles,
                                     selectedColor: category.color,
                                     unselectedColor: category.fadedColor)
                    Spacer()
                }
                .padding(.top, 24)
                
            }
            .padding(16)
            .background(.white)
            .cornerRadius(16)
        }
    }
}

struct ArticleIndicator:View {
    var currentIndicator: Int = 0
    var totalIndicators: Int
    var selectedColor: Color
    var unselectedColor: Color
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalIndicators, id: \.self) { i in
                Circle()
                    .fill(currentIndicator == i ? selectedColor : unselectedColor)
                    .frame(width: 12, height: 12)
            }
        }
    }
}

#Preview {
    
    ArticleCard(category: .meaning, article: "", articleTitle: "Qual o significado deste vitral?", articleDescription: "Utilização do estructural glazing, um sistema na forma de sanduíche de 5 lâminas de vidro, películas anti-raios UVA e UVB separadas por gás argônio, tudo encapsulado a vácuo.", numberOfArticles: 5)
        .padding()
        .background(.gray)
}
