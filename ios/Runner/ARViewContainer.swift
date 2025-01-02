import SwiftUI
import ARKit

struct ARViewControllerWrapper: UIViewControllerRepresentable {
    @ObservedObject var arViewModel: ARViewModel

    func makeUIViewController(context: Context) -> ARViewModel {
        return arViewModel
    }

    func updateUIViewController(_ uiViewController: ARViewModel, context: Context) {
        // Any updates to the ARViewModel if needed.
    }
}
