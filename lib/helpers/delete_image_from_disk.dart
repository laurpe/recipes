import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> deleteImageFromDisk(String path) async {
  final directory = await getApplicationDocumentsDirectory();

  final file = File('${directory.path}/images/$path');
  await file.delete();
}
