import 'package:camera/camera.dart';
import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/screen/tasks/model/task_files_model.dart';
import 'package:crm/screen/tasks/model/tasks_model.dart';
import 'package:crm/screen/tasks/repo/tasks_repo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TasksController extends GetxController {
  final Map<String, TextEditingController> controllers = {};
  final Map<String, FocusNode> focusNodes = {};

  final RxString noSearchController = ''.obs;
  final RxString selectedTypeOfWork = ''.obs;
  final RxList<TasksModel> filteredList = <TasksModel>[].obs;
  final RxList<TasksModel> taskList = <TasksModel>[].obs;

  bool isEdit = false;
  String? no;
  final dateFormat = DateFormat("d/M/yyyy");

  List<String> typeOfWorkList = ["Pending", "Processed", "Done"];

  final List<String> fields = [
    "no",
    "noSearch",
    "date",
    "taskDiscription",
    "assignedTo",
    "attached",
    "work",
    "workType",
  ];

  @override
  void onInit() {
    super.onInit();
    for (var field in fields) {
      controllers[field] = TextEditingController();
      focusNodes[field] = FocusNode();
    }
  }

  @override
  void onClose() {
    controllers.forEach((_, controller) => controller.dispose());
    focusNodes.forEach((_, node) => node.dispose());
    cameraController?.dispose();
    super.onClose();
  }

  void updateTypeOfWork(String? newValue) {
    if (newValue != null) {
      selectedTypeOfWork.value = newValue;
    }
  }

  void resetAllFields() {
    // controllers.forEach((_, controller) => controller.clear());
    controllers['date']!.clear();
    selectedTypeOfWork.value = '';
    controllers['taskDiscription']!.clear();
    attachedFiles.clear();
    // updateTypeOfWork('');
  }

  Future<void> setEditDetails(String no) async {
    showlog("No set edit details: $no");
    int intNo = int.parse(no);

    controllers['no']!.text = no;
    // final task = taskList.firstWhereOrNull((element) => element.id == intNo);
    // if (task != null) {
    //   controllers['date']!.text = task.date;
    //   controllers['taskDiscription']!.text = task.description;
    //   controllers['work']!.text = task.work;
    //   controllers['workType']!.text = task.work;
    //   selectedTypeOfWork.value = task.work;
    //   controllers['assignedTo']!.text = task.assignedTo.toString();
    // }

    controllers['date']!.text = taskList
        .firstWhereOrNull((element) => element.id == intNo)!
        .date;
    controllers['taskDiscription']!.text = taskList
        .firstWhereOrNull((element) => element.id == intNo)!
        .description;
    controllers['work']!.text = taskList
        .firstWhereOrNull((element) => element.id == intNo)!
        .work;
    controllers['workType']!.text = taskList
        .firstWhereOrNull((element) => element.id == intNo)!
        .work;
    selectedTypeOfWork.value = taskList
        .firstWhereOrNull((element) => element.id == intNo)!
        .work;
    controllers['assignedTo']!.text = taskList
        .firstWhereOrNull((element) => element.id == intNo)!
        .assignedTo
        .toString();

    // Fetch and set the attached file path
    final file = await getFileDetailsById(intNo);
    if (file.filePath.isNotEmpty) {
      attachedFiles.assign(file.filePath);
    }
    controllers['attached']!.text = await getFileDetailsById(
      intNo,
    ).then((value) => value.filePath);

    await getTaskList();
  }

  void searchResult(String val) {
    showlog("search for number : $val");

    if (val.isEmpty) {
      // If the search query is empty, show all contacts
      filteredList.value = taskList;
      return;
    }

    final lowerCaseQuery = val.toLowerCase();

    filteredList.value = taskList.where((item) {
      final no = item.id?.toString().toLowerCase();

      return (no?.contains(lowerCaseQuery) ?? false);
    }).toList();
  }

  // ---------- database handling ---------------------------------

  // get task lisk
  Future<void> getTaskList() async {
    try {
      final result = await TasksRepo.getAllTasks();
      taskList.assignAll(result);
      filteredList.value = taskList;
      showlog("task list : ${result.map((e) => e.toMap()).toList()}");
    } catch (e) {
      showlog("Error getting task list : $e");
    }
  }

  // get files list
  Future<void> getFilesList() async {
    try {
      final result = await TasksRepo.getAllTaskFiles();
      showlog("files list : ${result.map((e) => e.toJson()).toList()}");
    } catch (e) {
      showlog("Error getting files list : $e");
    }
  }

  // get task details by id
  Future<TasksModel> getTaskDetailsById(int id) async {
    try {
      final result = await TasksRepo.getTaskById(id);
      showlog("task details : ${result.toMap()}");
      return result;
    } catch (e) {
      showlog("Error getting task details : $e");
      rethrow;
    }
  }

  //get file by id
  Future<TaskFileModel> getFileDetailsById(int id) async {
    try {
      final result = await TasksRepo.getTaskFileByTaskId(id);
      showlog("file details : ${result.toJson()}");
      return result;
    } catch (e) {
      showlog("Error getting file details : $e");
      rethrow;
    }
  }

  // add new task
  Future<void> addTask() async {
    try {
      String filePath = attachedFiles.first;

      controllers['attached']!.text = filePath;

      showlog("selected type of work : ${selectedTypeOfWork.value}");

      final task = TasksModel(
        date: controllers['date']!.text,
        description: controllers['taskDiscription']!.text,
        work: selectedTypeOfWork.value,
        assignedTo: 0,
        // assignedTo: int.parse(controllers['assignedTo']!.text),
        filePath: controllers['attached']!.text,
      );

      showlog("added task ----> ${task.toMap()}");

      int result = await TasksRepo.insertTask(task);

      if (result != 0) {
        //add file to file table
        await addFile();
      }
      showlog("insert task ----> $result");
      await getTaskList();
    } catch (e) {
      showlog("Error adding task : $e");
    }
  }

  // add file
  Future<void> addFile() async {
    try {
      String filePath = attachedFiles.first;
      String fileExtension = filePath.split('.').last.toLowerCase();

      bool isImage = ['png', 'jpg', 'jpeg'].contains(fileExtension);

      showlog("adding file is image: $isImage");

      // Save the already selected file permanently
      final savedPath = await FileHelper.savePickedFile(
        originalPath: filePath,
        isImage: isImage,
      );

      if (savedPath == null) {
        showlog("File copy failed");
        return;
      }

      controllers['attached']!.text = savedPath;

      final file = TaskFileModel(
        taskId: int.parse(controllers['no']!.text),
        filePath: savedPath,
        fileType: fileExtension,
      );

      showlog("added file ----> ${file.toJson()}");

      int result = await TasksRepo.insertTaskFile(file);
      showlog("insert task file ----> $result");
    } catch (e) {
      showlog("Error adding file : $e");
    }
  }

  // update task
  Future<void> updateTask() async {
    try {
      showlog("selected type of work : ${selectedTypeOfWork.value}");
      final task = TasksModel(
        id: int.parse(controllers['no']!.text),
        date: controllers['date']!.text,
        description: controllers['taskDiscription']!.text,
        work: selectedTypeOfWork.value,
        assignedTo: 0,
        filePath: controllers['attached']!.text,
      );
      showlog("update task ----> ${task.toMap()}");
      int result = await TasksRepo.updateTask(task);

      if (result != 0) {
        await updateFile();
      }
      await getTaskList();
      showlog("updated task ----> $result");
    } catch (e) {
      showlog("Error update task : $e");
    }
  }

  // update file
  Future<void> updateFile() async {
    try {
      String filePath = attachedFiles.first;
      String fileExtension = filePath.split('.').last.toLowerCase();

      bool isImage = ['png', 'jpg', 'jpeg'].contains(fileExtension);

      showlog("adding file is image: $isImage");

      // Save the already selected file permanently
      final savedPath = await FileHelper.savePickedFile(
        originalPath: filePath,
        isImage: isImage,
      );

      if (savedPath == null) {
        showlog("File copy failed");
        return;
      }

      controllers['attached']!.text = savedPath;

      final file = TaskFileModel(
        taskId: int.parse(controllers['no']!.text),
        filePath: savedPath,
        fileType: fileExtension,
      );

      showlog("update file ----> ${file.toJson()}");
      int result = await TasksRepo.updateTaskFile(file);
      showlog("updated file ----> $result");
    } catch (e) {
      showlog("Error update file : $e");
    }
  }

  // delete task
  Future<int> deleteTask(int id) async {
    try {
      int result = await TasksRepo.deleteTask(id);
      if (result != 0) {
        await deleteFile(id);
      }
      await getTaskList();
      showlog("deleted task ----> $result");
      return result;
    } catch (e) {
      showlog("Error deleting task : $e");
      rethrow;
    }
  }

  // delete file
  Future<int> deleteFile(int id) async {
    try {
      int result = await TasksRepo.deleteTaskFile(id);
      showlog("deleted file ----> $result");
      return result;
    } catch (e) {
      showlog("Error deleting file : $e");
      rethrow;
    }
  }

  // ------------------------- doc handling -----------------------------

  CameraController? cameraController;
  late Future<void> initializeControllerFuture;
  final RxBool isInitialized = false.obs;

  final RxList<String> capturedImages = <String>[].obs;

  // Initialize camera
  Future<void> initCamera(List<CameraDescription> cameras) async {
    try {
      cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      initializeControllerFuture = cameraController!.initialize();
      await initializeControllerFuture;
      isInitialized.value = true;
      update(); // For GetBuilder if used
    } catch (e) {
      showlog("❌ Camera init error: $e");
    }
  }

  // Capture image
  Future<String?> captureImage() async {
    try {
      await initializeControllerFuture;
      final image = await cameraController!.takePicture();
      capturedImages.add(image.path);

      showlog("📸 Captured: ${image.path}");
      return image.path;
    } catch (e) {
      showlog("❌ Capture error: $e");
      return null;
    }
  }

  /// Rx list of selected file paths
  final RxList<String> attachedFiles = <String>[].obs;

  /// Pick a file from storage
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      attachedFiles.add(result.files.single.path!);
    }
  }

  /// Capture an image from camera
  Future<void> captureFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      attachedFiles.add(photo.path);
    }
  }

  /// Pick image from gallery
  Future<void> pickFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      attachedFiles.add(image.path);
    }
  }
}
