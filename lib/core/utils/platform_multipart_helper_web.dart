import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'platform_multipart_helper.dart';

class WebMultipartHelper implements PlatformMultipartHelper {
  @override
  Future<http.MultipartFile> createMultipartFile(PlatformFile file, String fieldName) async {
    if (file.bytes == null) {
      throw Exception("Fayl ma'lumotlari topilmadi (Web)");
    }
    return http.MultipartFile.fromBytes(
      fieldName,
      file.bytes!,
      filename: file.name,
    );
  }
}

PlatformMultipartHelper getHelper() => WebMultipartHelper();
