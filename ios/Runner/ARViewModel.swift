import UIKit
import ARKit
import RealityKit

class ARViewModel: UIViewController, ObservableObject, ARSessionDelegate {
    @Published var isImageRecognized: Bool = false
    @Published var recognizedImageTag: String?
    
    var planeEntities: [UUID: ModelEntity] = [:]  // Dictionary to track plane entities by anchor ID

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
    }

    private func setupImageTracking() {
        // Load reference images
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            print("Failed to load reference images.")
            return
        }
        
        // Set up ARImageTrackingConfiguration
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 1 // Optional: Limit to a single tracked image
        
        // Run the AR session with the image tracking configuration
        arView.session.run(configuration)
    }

    // ARSessionDelegate method
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let imageAnchor = anchor as? ARImageAnchor {
                // Image detected
                DispatchQueue.main.async {
                    self.isImageRecognized = true
                    self.recognizedImageTag = imageAnchor.referenceImage.name
                }
                addPlane(for: imageAnchor)
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if let imageAnchor = anchor as? ARImageAnchor {
                // Get the plane entity associated with this anchor
                if let plane = planeEntities[imageAnchor.identifier] {
                    // Update the position of the plane based on the anchor's new transform
                    plane.position = simd_make_float3(imageAnchor.transform.columns.3.x,
                                                      imageAnchor.transform.columns.3.y,
                                                      imageAnchor.transform.columns.3.z)
                    
                    let rotation = simd_quatf(angle: .pi / 4, axis: SIMD3<Float>(0, 1, 0)) // Rotate 45 degrees on the y-axis
                    plane.orientation = rotation
                }
            }
        }
    }

    // Add plane to the AR scene where image was detected
    private func addPlane(for imageAnchor: ARImageAnchor) {
        // Generate the plane based on the reference image size
        let plane = ModelEntity(mesh: .generatePlane(width: Float(imageAnchor.referenceImage.physicalSize.width),
                                                    height: Float(imageAnchor.referenceImage.physicalSize.height)))
        
        // Assign a material to the plane (can be any material)
        plane.model?.materials = [UnlitMaterial(color: .red)]
        
        // Create an AnchorEntity using the image anchor's transform
        let anchorEntity = AnchorEntity(world: imageAnchor.transform)
        
        // Add the plane as a child of the anchor entity
        anchorEntity.addChild(plane)
        
        // Add the anchor entity to the AR view's scene
        arView.scene.addAnchor(anchorEntity)
        
        // Store the plane entity in the dictionary for future updates
        planeEntities[imageAnchor.identifier] = plane
    }
    
    // Function to reset the image recognition flag
    func resetImageRecognizedFlag() {
        DispatchQueue.main.async {
            self.isImageRecognized = false
        }
    }
}
