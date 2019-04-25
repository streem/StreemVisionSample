
### Documentation

#### iOS Quickstart

Clone our test app on [Github](https://github.com/streem/StreemVisionSample.git)

#### Create a smart session

```
override func viewDidLoad() {
    /* …  */

    // Initialize session with your API key
    smartSession.init(apiKey: “123asd”, sceneView: sceneView)
    smartSession.delegate = self

    // Assign a delegate for processing frames from the arkit session
    frameHandler = ARSessionDelegateHandler(session: smartSession)
    sceneView.session.delegate = frameHandler

    // Run the session
    smartSession.run()
}
```


#### Visualize the scene mesh

Frames are processed in the background and a mesh is built of the scene. By default, this mesh is visible via the debug mode.

For a transparent mesh use - (default)
```
smartSession.toggleDebugMode()
```

For toggling the mesh colors use the following -

```
smartSession.toggleMeshColoring()
```


#### Detect physical objects

The ARSmartSession automatically detect objects. You can pause/restart the detection loop with the `autodetect` attribute, or call the `detect()` method as needed.

```
smartSession.autodetect = true
/* or */
smartSession.detect()
```

#### Attach content to smart anchors

Attach virtual content to smart anchors just like other arkit anchor types

```
optional func renderer(_ renderer: SCNSceneRenderer,  didAdd node: SCNNode,   for anchor: ARAnchor) {
      if let smartAnchor = anchor as? ARSmartAnchor {
        // attach a relevant gif to the smart anchor
        if (smartAnchor.label == "laptop") {
            createSCNNodeFromTextureURL(
              url: URL(string:"https://media.giphy.com/media/3o7aCSxsasvg9LjJDy/giphy.gif")!) { asset in
                node.addChildNode(asset)
            }
        }

        // add more virtual content depending on the smart anchor label
        return;
      }

      // Handle other types of nodes
      If let planeAnchor = anchor as ARPlaneAnchor { /* .. */; }
}
```