import SwiftUI
import ARKit

struct ContentView : View {
    var channel: FlutterMethodChannel
    @ObservedObject var arViewModel : ARViewModel = ARViewModel()
    var body: some View {
        ZStack {
            ARViewContainer(arViewModel: arViewModel).edgesIgnoringSafeArea(.all)

            VStack(alignment: .center) {

                HStack {
                    Button {
                        arViewModel.resetImageRecognizedFlag()
                    } label: {
                        VStack {
                            Image("camera")
                            Text("RA")
                        }
                    }

                    Spacer()

                    Button {
                        channel.invokeMethod("goBack", arguments: nil)
                    } label: {
                        VStack {
                            Image("home")
                            Text("MENU")
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
                }
            }
            .padding(.bottom, 50)
            .multilineTextAlignment(.center)
        }

    }
}
