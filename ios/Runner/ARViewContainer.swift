//
//  ARViewContainer.swift
//  Runner
//
//  Created by Alessandra Fernandes Lacerda on 11/12/24.
//
import SwiftUI
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    var arViewModel: ARViewModel

    func makeUIView(context: Context) -> ARView {
        arViewModel.startSessionDelegate()
        return arViewModel.arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

}
