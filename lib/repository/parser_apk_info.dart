import 'dart:io';

import 'package:meta/meta.dart';
import 'package:parser_apk_info/model/apk_info.dart';

abstract class ParserApkInfo {

  @visibleForTesting
  Future<ApkInfo?> parseString(final File file, final String dataString);

  Future<ApkInfo?> parseFile(File file);

  Future<List<ApkInfo>?> parseFiles(Iterable<File> files);
}
