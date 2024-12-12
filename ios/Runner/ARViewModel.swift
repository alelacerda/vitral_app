//
//  ARViewModel.swift
//  Runner
//
//  Created by Alessandra Fernandes Lacerda on 11/12/24.
//

import Foundation
import RealityKit
import ARKit


class ARViewModel: UIViewController, ObservableObject, ARSessionDelegate {
    @Published private var model : ARModel = ARModel()

    var arView : ARView {
        model.arView
    }

    var isImageRecognized : Bool {
        model.isImageRecognized
    }

    func startSessionDelegate() {
        model.arView.session.delegate = self
    }

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        model.isImageRecognized(anchors: anchors)
    }

    // todo: reset image recognition
    func resetImageRecognizedFlag() {
        model.isImageRecognized = false
    }

}
