import SwiftUI
import ARKit

struct ContentView : View {
    var channel: FlutterMethodChannel
    @ObservedObject var arViewModel : ARViewModel = ARViewModel()
    @State private var stainedGlassInfoArray: [StainedGlassInfo] = []
    var body: some View {
        ZStack {
            ARViewControllerWrapper(arViewModel: arViewModel)
                            .edgesIgnoringSafeArea(.all)

            VStack(alignment: .center) {
                CategorySelector()
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
            } else if let stainedGlassInfoList = result as? [[String: Any]] { // Expecting a list of dictionaries
                let parsedList = stainedGlassInfoList.compactMap { dictionary -> StainedGlassInfo? in
                    return StainedGlassInfo.fromDictionary(dictionary)
                }
                
                DispatchQueue.main.async {
                    self.stainedGlassInfoArray = parsedList
                }
            } else {
                print("Unknown result type")
            }
        }
    }
}
