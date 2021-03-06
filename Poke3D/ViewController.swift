//
//  ViewController.swift
//  Poke3D
//
//  Created by Michael Knych on 7/15/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Add defult lighting to the scene
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration to track and recognize
        // a specific set of images
        let configuration = ARImageTrackingConfiguration()
        
        // specify the images to track
        // Bundle.main is the current file or project we are in
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
            
            configuration.trackingImages = imageToTrack
            
            configuration.maximumNumberOfTrackedImages = 2
            
            print("Imagers Successfully Added!!!")
        }

        // Run the view's session
        // will triggr the rendere delagate func to execute
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    // Add a scenekit node corresponding to a newly added anchor
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        
        let node = SCNNode()
        
        var sceneImage = ""
        
        // create a new thread execution for each scene created
        DispatchQueue.main.async {
            
        // place a 2D plane on the recognized image and then
        // and then place a 3D model scene on the created plane
        // that corresponds to the recognized image
        if let imageAnchor = anchor as? ARImageAnchor {
            
            print(imageAnchor.referenceImage.name!)
            
            let plane = SCNPlane(
                width: imageAnchor.referenceImage.physicalSize.width,
                height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.6)
            
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.eulerAngles.x = -.pi / 2
            
            node.addChildNode(planeNode)
            
            if imageAnchor.referenceImage.name == "eeve-card" {
                sceneImage = "art.scnassets/eevee.scn" }
            else {
                sceneImage = "art.scnassets/oddish.scn"
            }
            
            if let pokeScene = SCNScene(named: sceneImage) {
                
                if let pokeNode = pokeScene.rootNode.childNodes.first {
                    
                    pokeNode.eulerAngles.x = .pi / 2
                    
                    planeNode.addChildNode(pokeNode)
                    
                }
                
            }
            
        }
            
            
        }
        
        return node
        
    }
    
}
