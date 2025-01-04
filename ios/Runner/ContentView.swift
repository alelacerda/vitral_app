import SwiftUI
import ARKit

struct ContentView : View {
    var channel: FlutterMethodChannel
    @ObservedObject var arViewModel : ARViewModel = ARViewModel()
    @State private var stainedGlassInfoArray: [StainedGlassInfo] = []
    
    @State private var selectedCategory: Category? = nil

    var body: some View {
        ZStack {
            ARViewControllerWrapper(arViewModel: arViewModel)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    arViewModel.onMarkerSelected = { markerUUID in
                        stainedGlassInfoArray.first { $0.id == markerUUID }?.category
                    }
                }

            VStack(alignment: .center) {
                CategorySelector(selectedCategory: $selectedCategory)
                    .onChange(of: selectedCategory) { category in
                        updateMarkersForCategory(category)
                        arViewModel.selectedMarker = nil
                    }
                HStack {
                    Button {
                        arViewModel.resetImageRecognizedFlag()
                    } label: {
                        VStack {
                            Image("camera")
                            Text("RA")
                                .font(Fonts.button)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        channel.invokeMethod("goBack", arguments: nil)
                    } label: {
                        VStack {
                            Image("home")
                            Text("MENU")
                                .font(Fonts.button)
                        }
                    }
                }
                .foregroundStyle(.white)
                .padding(30)
                
                Spacer()
                
                if !arViewModel.isImageRecognized {
                    Image("camera-viewfinder")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text("Aponte sua câmera\npara o vitral".uppercased())
                        .font(.title)
                        .padding(.bottom, 50)
                        .multilineTextAlignment(.center)
                        .onDisappear {
                            if let tag = arViewModel.recognizedImageTag {
                                fetchStainedGlassInfo(tag: tag)
                            }
                        }
                }
                else if let stainedGlassInfoId = arViewModel.selectedMarker, let info  = stainedGlassInfoArray.first(where: {$0.id == stainedGlassInfoId}) {
                
                    let infoCategory = stainedGlassInfoArray.filter({$0.category == info.category})
                    
                    ArticleCard(
                        category: info.category,
                        article: info.articleId,
                        articleTitle: info.title,
                        articleImage: info.imageUrl,
                        articleDescription: info.description,
                        currentArticleIndex: infoCategory.firstIndex(where: {$0.id == info.id}) ?? 0,
                        numberOfArticles: infoCategory.count
                    )
                    .padding(.horizontal, 20)
                }
            }
        }

    }
    
    func fetchStainedGlassInfo(tag: String) {
        channel.invokeMethod("getStainedGlassInfo", arguments: tag) { result in
            if let error = result as? FlutterError {
                print("Error: \(error.message ?? "Unknown error")")
            } else if let jsonData = try? JSONSerialization.data(withJSONObject: result, options: []) {
                do {
                    let stainedGlassInfoList = try JSONDecoder().decode([StainedGlassInfo].self, from: jsonData)
                    DispatchQueue.main.async {
                        self.stainedGlassInfoArray = stainedGlassInfoList
                        
                        self.selectedCategory = .funfacts
                        
                        let filteredStainedGlassInfoList = stainedGlassInfoList.filter { $0.category == self.selectedCategory }
                        for stainedGlassInfo in filteredStainedGlassInfoList {
                            self.arViewModel.addMarker(
                                x: stainedGlassInfo.position[0],
                                z: stainedGlassInfo.position[1],
                                color: UIColor(stainedGlassInfo.category.color),
                                id: stainedGlassInfo.id
                            )
                        }
                    }
                } catch {
                    print("Decoding failed: \(error)")
                }
            } else {
                print("Unknown result type")
            }
        }
    }
    
    func updateMarkersForCategory(_ category: Category?) {
        guard let category = category else { return }
        
        let filteredStainedGlassInfoList = stainedGlassInfoArray.filter { $0.category == category }
        
        arViewModel.clearMarkers()
        
        for stainedGlassInfo in filteredStainedGlassInfoList {
            arViewModel.addMarker(
                x: stainedGlassInfo.position[0],
                z: stainedGlassInfo.position[1],
                color: UIColor(stainedGlassInfo.category.color),
                id: stainedGlassInfo.id
            )
        }
    }
}
