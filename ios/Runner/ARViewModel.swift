import UIKit
import ARKit
import RealityKit

class ARViewModel: UIViewController, ObservableObject, ARSessionDelegate {
    @Published var isImageRecognized: Bool = false
    @Published var recognizedImageTag: String?
    @Published var selectedMarker: UUID?

    var markerEntities: [UUID: ModelEntity] = [:]
    var backgroundEntities: [UUID: ModelEntity] = [:]
    var imageAnchor: ARImageAnchor?
    var arView: ARView!
    
    var onMarkerSelected: ((UUID) -> Category?)?

    override func viewDidLoad() {
        super.viewDidLoad()

        arView = ARView(frame: self.view.bounds)
        arView.session.delegate = self

        self.view.addSubview(arView)

        setupImageTracking()

        addTapGestureRecognizer()
    }

    private func setupImageTracking() {
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

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let imageAnchor = anchor as? ARImageAnchor {
                DispatchQueue.main.async {
                    self.imageAnchor = imageAnchor
                    self.isImageRecognized = true
                    self.recognizedImageTag = imageAnchor.referenceImage.name
                }
            }
        }
    }

    func addMarker(x: Float = 0, z: Float = 0, color: UIColor, id: UUID) {
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

        let anchorEntity = AnchorEntity(world: imageAnchor.transform)

        anchorEntity.addChild(circleEntity)

        arView.scene.addAnchor(anchorEntity)

        markerEntities[id] = innerCircleEntity
        backgroundEntities[id] = circleEntity
    }

    private func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        arView.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: arView)
        if let tappedEntity = arView.entity(at: tapLocation) as? ModelEntity {
            if let markerUUID = markerEntities.first(where: { $0.value == tappedEntity })?.key {
                DispatchQueue.main.async {
                    self.selectedMarker = markerUUID
                    
                    if let category = self.onMarkerSelected?(markerUUID),
                       let markerEntity = self.markerEntities[markerUUID] {
                        let fadedMaterial = UnlitMaterial(color: UIColor(category.fadedColor))
                        markerEntity.model?.materials = [fadedMaterial]
                    }
                }
                print("Marker with UUID \(markerUUID) tapped.")
            }
        }
    }

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
