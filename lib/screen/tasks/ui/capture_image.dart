import 'package:camera/camera.dart';
import 'package:crm/screen/tasks/controller/tasks_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraScreen extends StatelessWidget {
  final List<CameraDescription> cameras;
  const CameraScreen({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    final TasksController cameraCtrl = Get.put(TasksController());

    // Initialize the camera when screen opens
    cameraCtrl.initCamera(cameras);

    return Scaffold(
      backgroundColor: Colors.black,
      body: GetBuilder<TasksController>(
        builder: (ctrl) {
          if (!ctrl.isInitialized.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Stack(
            children: [
              /// Camera Preview
              Positioned.fill(child: CameraPreview(ctrl.cameraController!)),

              /// Bottom capture controls
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Capture Button
                      GestureDetector(
                        onTap: () async {
                          final imagePath = await ctrl.captureImage();
                          if (imagePath != null) {
                            Get.back(result: imagePath);
                          }
                        },
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
