import 'package:file_picker/file_picker.dart';

class FilePickerHelper {
  Future<PlatformFile?> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'txt'],
      );

      if (result != null) {
        return result.files.single;
      }
      return null;
    } catch (e) {
      print("File picking error: $e");
      return null;
    }
  }
}
