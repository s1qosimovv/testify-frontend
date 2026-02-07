import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'platform_multipart_helper.dart';

class MobileMultipartHelper implements PlatformMultipartHelper {
  @override
  Future<http.MultipartFile> createMultipartFile(PlatformFile file, String fieldName) async {
    if (file.path == null) {
      throw Exception("Fayl manzili topilmadi (Mobile)");
    }
    return await http.MultipartFile.fromPath(fieldName, file.path!);
  }
}

PlatformMultipartHelper getHelper() => MobileMultipartHelper();
