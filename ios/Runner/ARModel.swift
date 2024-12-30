//
import Foundation
import RealityKit
import ARKit

struct ARModel {
    private(set) var arView: ARView
    var isImageRecognized: Bool = false
    var recognizedImageTag: String? = nil // Store the tag of the recognized image

    init() {
        guard let trackerImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }

        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = trackerImages

        arView = ARView(frame: .zero)
        arView.session.run(configuration)
    }

    mutating func isImageRecognized(anchors: [ARAnchor]) {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }

        for anchor in anchors {
            if let imageAnchor = anchor as? ARImageAnchor {
                let detectedImage = imageAnchor.referenceImage

                // Match the detected image to the reference images to find its name (tag)
                if let imageName = detectedImage.name {
                    self.recognizedImageTag = imageName
                    self.isImageRecognized = true
                    return
                }
            }
        }

        // Reset if no image is recognized
        self.recognizedImageTag = nil
        self.isImageRecognized = false
    }
}
