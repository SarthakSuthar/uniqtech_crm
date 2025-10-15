import 'dart:developer';
import 'dart:io';
import 'package:crm/screen/login/repo/user_repo.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static Future<String?> savePickedFile({
    required String originalPath,
    required bool isImage,
  }) async {
    final selectedFile = File(originalPath);

    if (!await selectedFile.exists()) return null;

    // Get app's permanent directory
    Directory appDocDir = await getApplicationDocumentsDirectory();

    // Create custom sub-folder (Documents & Images inside DICABS CRM)
    String folderName = isImage ? "Images" : "Documents";
    String customDirPath = "${appDocDir.path}/DICABS CRM/$folderName";
    Directory customDir = Directory(customDirPath);

    AppUtils.showlog("Saved file path: $customDir");

    if (!await customDir.exists()) {
      await customDir.create(recursive: true);
    }

    // Save with original file name (or add timestamp if already exists)
    String fileName = selectedFile.uri.pathSegments.last;
    String newPath = "$customDirPath/$fileName";

    if (await File(newPath).exists()) {
      String name = fileName.split('.').first;
      String ext = fileName.split('.').last;
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      newPath = "$customDirPath/${name}_$timestamp.$ext";
    }

    File newFile = await selectedFile.copy(newPath);
    return newFile.path; // permanent file path
  }
}

class AppUtils {
  static Future<String> uid = (() async {
    return await UserRepo.getUserId();
  })();

  ///green coloured log
  static void showlog(String msg) {
    log('\x1B[32m$msg\x1B[0m');
  }
}
