//
//  ARModel.swift
//  Runner
//
//  Created by Alessandra Fernandes Lacerda on 11/12/24.
//

import Foundation
import RealityKit
import ARKit

struct ARModel {
    private(set) var arView : ARView

    var isImageRecognized: Bool = false

    init() {
        guard let trackerImage = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }

        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = trackerImage

        arView = ARView(frame: .zero)
        arView.session.run(configuration)
    }

    mutating func isImageRecognized(anchors: [ARAnchor]) {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }

        // add logic here to identify target image anchor
        for anchor in anchors {
            guard let imageAnchor = anchor as? ARImageAnchor else { return }
            isImageRecognized = true
        }
    }
}
