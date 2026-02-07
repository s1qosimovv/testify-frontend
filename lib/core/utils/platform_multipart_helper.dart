import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

abstract class PlatformMultipartHelper {
  Future<http.MultipartFile> createMultipartFile(PlatformFile file, String fieldName);
}

PlatformMultipartHelper getHelper() => throw UnsupportedError('Cannot create helper without platform implementation');
