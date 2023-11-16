import 'dart:io';

import 'package:path/path.dart' as p;

class AaptUtil {
  static const String aaptAppWin = 'aapt2.exe';
  static const String aaptApp = 'aapt2';
  static const String apkExt = '.apk';

  static String getAapt() {
    if (Platform.isWindows) {
      return aaptAppWin;
    } else {
      return aaptApp;
    }
  }

  static Future<String?> getAaptApp(String? aaptDirPath) async {
    if (aaptDirPath == null) return null;
    final aaptPath = p.join(aaptDirPath, getAapt());
    final aapt = File(aaptPath);
    if (!(await aapt.exists())) {
      return null;
    }
    try {
      final processResult = await Process.run(
        aapt.path,
        ['version'],
      );
      final String resultString = processResult.stderr;
      if (processResult.exitCode == 0 &&
          resultString.startsWith('Android Asset Packaging Tool')) {
        return aapt.path;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}