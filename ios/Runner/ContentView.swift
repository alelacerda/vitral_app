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

            VStack(alignment: .center) {
                CategorySelector(selectedCategory: $selectedCategory)
                    .onChange(of: selectedCategory) { category in
                        updateMarkersForCategory(category)
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
                } else if let tag = arViewModel.recognizedImageTag {
                    buildStainedGlassInfoView(tag: tag)
                    
                    
                }
            }
            .padding(.bottom, 50)
            .multilineTextAlignment(.center)
        }

    }
    
    @ViewBuilder
    func buildStainedGlassInfoView(tag: String) -> some View {
        VStack {
            Text("Imagem reconhecida:")
                .font(.headline)
                .padding(.bottom, 5)
            Text(tag)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
        }.onAppear {
            fetchStainedGlassInfo(tag: tag)
        }
        .foregroundColor(.white)
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
                        
                        let filteredStainedGlassInfoList = stainedGlassInfoList.filter { $0.category == self.selectedCategory }
                        for stainedGlassInfo in filteredStainedGlassInfoList {
                            self.arViewModel.addMarker(
                                x: stainedGlassInfo.position[0],
                                z: stainedGlassInfo.position[1],
                                color: UIColor(stainedGlassInfo.category.color)
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
        
        // Filter the stained glass info by the selected category
        let filteredStainedGlassInfoList = stainedGlassInfoArray.filter { $0.category == category }
        
        // Clear existing markers
        arViewModel.clearMarkers()
        
        // Add new markers for the selected category
        for stainedGlassInfo in filteredStainedGlassInfoList {
            arViewModel.addMarker(
                x: stainedGlassInfo.position[0],
                z: stainedGlassInfo.position[1],
                color: UIColor(stainedGlassInfo.category.color)
            )
        }
    }
}
