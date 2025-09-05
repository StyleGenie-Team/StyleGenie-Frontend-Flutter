import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart';

class SimpleAR extends StatefulWidget {
  const SimpleAR({super.key});

  @override
  State<SimpleAR> createState() => _SimpleARState();
}

class _SimpleARState extends State<SimpleAR> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AR تجربة سريعة")),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontal,
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () async {
                setState(() => isLoading = true);

                var newNode = ARNode(
                  type: NodeType.webGLB,
                  uri: "https://modelviewer.dev/shared-assets/models/Astronaut.glb",
                  scale: Vector3(0.2, 0.2, 0.2),
                  position: Vector3(0, 0, 0),
                );

                bool? added = await arObjectManager?.addNode(newNode);
                debugPrint("تمت الإضافة؟ $added");

                setState(() => isLoading = false);
              },
              child: const Text("أضف موديل AR"),
            ),
          )
        ],
      ),
    );
  }

  void onARViewCreated(
    ARSessionManager sessionManager,
    ARObjectManager objectManager,
    ARAnchorManager anchorManager,
    ARLocationManager locationManager,
  ) {
    arSessionManager = sessionManager;
    arObjectManager = objectManager;

    arSessionManager?.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "images/triangle.png",
      showWorldOrigin: true,
    );
    arObjectManager?.onInitialize();
  }

  @override
  void dispose() {
    arSessionManager?.dispose();
    super.dispose();
  }
}
