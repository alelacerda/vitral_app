import UIKit
import ARKit
import RealityKit

class ARViewModel: UIViewController, ObservableObject, ARSessionDelegate {
    @Published var isImageRecognized: Bool = false
    @Published var recognizedImageTag: String?

    var markerEntities: [UUID: ModelEntity] = [:]
    var backgroundEntities: [UUID: ModelEntity] = [:]
    
    var imageAnchor: ARImageAnchor?

    var arView: ARView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize ARView and set its session delegate
        arView = ARView(frame: self.view.bounds)
        arView.session.delegate = self

        // Add ARView to the current view
        self.view.addSubview(arView)

        // Configure AR view
        setupImageTracking()

        // Add tap gesture recognizer
        addTapGestureRecognizer()
    }

    private func setupImageTracking() {
        // Load reference images
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            print("Failed to load reference images.")
            return
        }

        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 1
        configuration.automaticImageScaleEstimationEnabled = true

        arView.session.run(configuration)
    }

    // ARSessionDelegate method
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let imageAnchor = anchor as? ARImageAnchor {
                // Image detected
                DispatchQueue.main.async {
                    self.imageAnchor = imageAnchor
                    self.isImageRecognized = true
                    self.recognizedImageTag = imageAnchor.referenceImage.name
                }
            }
        }
    }

    // Add plane to the AR scene where image was detected
    func addMarker(x: Float = 0, z: Float = 0, color: UIColor) {
        guard let imageAnchor else { return }
        
        let imageWidth = imageAnchor.referenceImage.physicalSize.width
        let imageHeight = imageAnchor.referenceImage.physicalSize.height
        
        let innerCircle = MeshResource.generatePlane(width: Float(imageWidth)*0.14, depth: Float(imageWidth)*0.14, cornerRadius: Float(imageWidth)*0.08)
        
        let outerCircle = MeshResource.generatePlane(width: Float(imageWidth)*0.18, depth: Float(imageWidth)*0.18, cornerRadius: Float(imageWidth)*0.1)
        
        let mainMaterial = UnlitMaterial(color: color)
        let borderMaterial = UnlitMaterial(color: .white)
        
        let circleEntity = ModelEntity(mesh: outerCircle)
        circleEntity.model?.materials = [borderMaterial]
        
        let innerCircleEntity = ModelEntity(mesh: innerCircle)
        innerCircleEntity.model?.materials = [mainMaterial]
        innerCircleEntity.position = SIMD3<Float>(0, 0.00001, 0)
        innerCircleEntity.generateCollisionShapes(recursive: true)
        circleEntity.addChild(innerCircleEntity)
        

        circleEntity.orientation = simd_quatf(angle: .pi / 2, axis: SIMD3<Float>(0, 0, 0))

        circleEntity.position.x = x * Float(imageAnchor.referenceImage.physicalSize.width / 2)
        circleEntity.position.y = 0
        circleEntity.position.z = z * Float(imageAnchor.referenceImage.physicalSize.height / 2)
        
        // Create an AnchorEntity using the image anchor's transform
        let anchorEntity = AnchorEntity(world: imageAnchor.transform)

        // Add the plane as a child of the anchor entity
        anchorEntity.addChild(circleEntity)

        // Add the anchor entity to the AR view's scene
        arView.scene.addAnchor(anchorEntity)

        // Store the plane entity in the dictionary for future updates
        markerEntities[imageAnchor.identifier] = innerCircleEntity
        backgroundEntities[imageAnchor.identifier] = circleEntity
    }

    // Add tap gesture recognizer to detect taps on planes
    private func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        arView.addGestureRecognizer(tapGesture)
    }

    // Handle tap gestures
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        // Get the tap location in the ARView
        let tapLocation = sender.location(in: arView)
        
        // Perform a hit test to check if the tap hit any entity
        if let tappedEntity = arView.entity(at: tapLocation) as? ModelEntity {
            // Check if the tapped entity is a plane in the planeEntities dictionary
            
            if let planeUUID = markerEntities.first(where: { $0.value == tappedEntity })?.key {
                // Change the color of the plane's material
//                tappedEntity.model?.materials = [UnlitMaterial(color: .blue)]

                print("Plane with UUID \(planeUUID) was tapped.")
            }
        }
    }

    // Function to reset the image recognition flag
    func resetImageRecognizedFlag() {
        DispatchQueue.main.async {
            self.isImageRecognized = false
        }
    }
    
    func clearMarkers() {
        for (_, entity) in markerEntities {
            entity.removeFromParent()
        }
        
        for (_, entity) in backgroundEntities {
            entity.removeFromParent()
        }
        markerEntities.removeAll()
        backgroundEntities.removeAll()
    }
}
