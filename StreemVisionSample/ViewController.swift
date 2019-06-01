//
//  ViewController.swift
//  StreemVisionSample
//
//  Created by PavanK on 4/24/19.
//  Copyright © 2019 Streem. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import StreemVision

class ViewController: UIViewController, ARSCNViewDelegate, ARSmartSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!

    var label = UILabel()
    var toast = UIVisualEffectView()

    var smartSession : ARSmartSession!
    var frameHandler : ARSessionDelegateHandler!

    var streemAPIKey = "YOUR_STREEM_API_KEY"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

        // Create a new scene
        let scene = SCNScene()

        // Set the scene to the view
        sceneView.scene = scene

        let handleSwipeLeftGestureRecon = UISwipeGestureRecognizer(target: self,
                                                                   action: #selector(userSwipeLeft))
        sceneView.addGestureRecognizer(handleSwipeLeftGestureRecon)
        let handleTapGestureRecon = UITapGestureRecognizer(target: self,
                                                           action: #selector(userTappedScreen))
        sceneView.addGestureRecognizer(handleTapGestureRecon)


        // *** Initialize StreemVision SDK ***
        // Create a smart session
        smartSession = ARSmartSession(apiKey: streemAPIKey, sceneView: sceneView)
        smartSession.delegate = self
        smartSession.toggleMeshColoring()

        // Assign a delegate for processing frames from the arkit session
        frameHandler = ARSessionDelegateHandler(session: smartSession)
        sceneView.session.delegate = frameHandler

        // Run the session
        smartSession.run()

        // auto detect objects and their pose
        smartSession.autodetect = true
    }

    //Toggle view of mapping mesh
    @objc func userSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        self.smartSession.toggleDebugMode()
    }

    //Drop tennis balls in the scene
    @objc func userTappedScreen(_ sender: UITapGestureRecognizer) {
        // Get the 2D point of the touch in the SceneView
        let tapPoint: CGPoint = sender.location(in: self.sceneView)
        let targetPosition: SCNVector3? = hitTestLocation(sceneView: sceneView, tapPoint: tapPoint)

        if (targetPosition == nil) {
            return;
        }

        //Create ball
        let sphere = SCNSphere(radius: 0.08)
        sphere.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/TennisBallColorMap.jpg")

        let newBall = addVirtualObjectAt(geometry: sphere, position: targetPosition!)
        sceneView.scene.rootNode.addChildNode(newBall)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true

        // Run the view's session
        sceneView.session.run(configuration)
        sceneView.automaticallyUpdatesLighting = true

        self.setupToast()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate


    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
/*
        // Can call a custom ar interaction like below. For demo we just return an empty node
        if let smartAnchor = anchor as? ARSmartAnchor {
            return nodeForSmartAnchor(smartAnchor)
        }
 */
        return SCNNode()
    }

/*
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user

    }

    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay

    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required

    }
 */

    // MARK: ARSmartSessionDelegate

    func session(_ session: ARSmartSession, didFailWithError error: Error) {
        print("ARSmartSession error: \(error)")
    }

    func session(_ session: ARSmartSession, didDetectScene scene: ARPhysicalScene?) {
        if let scene = scene {
            print("Number of smart anchors detected: \(scene.anchors.count)")
        } else {
            print("No smart anchor has yet been detected.")
        }
    }

    func session(_ session: ARSmartSession, didGetInfo info: String) {
        // Present the info being sent
        DispatchQueue.main.async{
            let defaultString = "1. Move around to map your space.\t\n  2. Tap on the map to drop tennis balls. \n3. Swipe right to toggle debug mode.";
            self.showToast(info)
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (timer) in
                if (defaultString.count > 0) {self.showToast(defaultString);}
                else {self.hideToast()}
            }
        }
    }

    // *** AR Interactions ***
    func nodeForSmartAnchor(_ anchor: ARSmartAnchor) -> SCNNode {
        let node = SCNNode()
        if anchor.label == "laptop" {
            createSCNNodeFromTextureURL(url: URL(string:"https://media.giphy.com/media/3o7aCSxsasvg9LjJDy/giphy.gif")!) { asset in
                if let asset = asset {
                    asset.position = SCNVector3(0.0,0.15,0.03)
                    asset.scale = SCNVector3(0.3,0.3,0.3)
                    node.addChildNode(asset)
                }
            }
        }
        return node
    }


}
