import SwiftUI

struct InformationCard: View {
    var category: Category
    var article: String?
    var informationTitle: String
    var informationImage: String?
    var informationDescription: String
    var currentCardIndex: Int = 0
    var numberOfCards: Int
    
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
                Text(informationTitle)
                    .font(Fonts.title2)
                    .foregroundStyle(.black)
                    .padding(.bottom, 8)
                
                HStack {
                    if let imageUrl = informationImage, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image.resizable()
                                     .scaledToFit()
                                     .frame(width: 100, height: 100) // Adjust the frame as needed
                            case .failure:
                                Text("Failed to load image")
                                    .foregroundColor(.red)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    
                    Text(informationDescription)
                        .multilineTextAlignment(.leading)
                        .font(Fonts.body)
                        .foregroundStyle(.black)
                }
                
                HStack {
                    Spacer()
                    ArticleIndicator(currentIndicator: currentCardIndex,
                                     totalIndicators: numberOfCards,
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
    InformationCard(category: .meaning, article: "", informationTitle: "Qual o significado deste vitral?", informationDescription: "Utilização do estructural glazing, um sistema na forma de sanduíche de 5 lâminas de vidro, películas anti-raios UVA e UVB separadas por gás argônio, tudo encapsulado a vácuo.", numberOfCards: 5)
        .padding()
        .background(.gray)
}
