import UIKit
import ARKit
import SceneKit
class ViewController: UIViewController {

    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var sceneView: ARSCNView!
    var arConfig: ARWorldTrackingConfiguration = ARWorldTrackingConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        arConfig.planeDetection = .horizontal
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.session.run(arConfig)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func randomFloat(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min)
    }
    func addObjects() {
        
    }
    @IBAction func addCube(_ sender: Any) {
        print("add cube")
        let cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        let cc = getCameraCoordinates(sceneView: sceneView)
        print(cc.x)
        print(cc.y)
        print(cc.z)
        cubeNode.position = SCNVector3(cc.x, cc.y, cc.z)
        
        sceneView.scene.rootNode.addChildNode(cubeNode)
    }
    
    @IBAction func addCup(_ sender: Any) {
        print("add cup")
        let cupNode = SCNNode()
        
        let cc = getCameraCoordinates(sceneView: sceneView)
        cupNode.position = SCNVector3(cc.x + 10, cc.y, cc.z)
        guard let virtualObjectScene = SCNScene(named: "Models.scnassets/Mario/mario.scn") else {
            print("failed")
            return
        }
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes {
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            wrapperNode.addChildNode(child)
        }
        cupNode.addChildNode(wrapperNode)
        
        sceneView.scene.rootNode.addChildNode(cupNode)
    }
    func getCameraCoordinates(sceneView: ARSCNView) -> CameraCoordinates  {
        let cameraTransform = sceneView.session.currentFrame?.camera.transform
        let cameraCoordinates = MDLTransform(matrix: cameraTransform!)
        var cc = CameraCoordinates()
        cc.x = cameraCoordinates.translation.x
        cc.y = cameraCoordinates.translation.y
        cc.z = cameraCoordinates.translation.z
        
        return cc
    }
}

