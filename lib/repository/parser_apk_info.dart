import 'dart:convert';
import 'dart:io';

import 'package:parser_apk_info/model/apk_info.dart';
import 'package:parser_apk_info/repository/logger.dart';
import 'package:parser_apk_info/repository/uuid.dart';
import 'package:path/path.dart' as p;

class ParserApkInfo {
  static const String aaptAppWin = 'aapt2.exe';
  static const String aaptApp = 'aapt2';
  static const String apkExt = '.apk';

  ParserApkInfo(this._logger);

  final Logger _logger;

  static String getAapt() {
    if (Platform.isWindows) {
      return aaptAppWin;
    } else {
      return aaptApp;
    }
  }

  String? _aaptPath;

  final _splitter = const LineSplitter();
  final _regExpPackage = RegExp(r"name='([^']+)' "
      r"versionCode='([^']+)' "
      r"versionName='([^']+)' "
      r"platformBuildVersionName='([^']+)' "
      r"platformBuildVersionCode='([^']+)' "
      r"compileSdkVersion='([^']+)' "
      r"compileSdkVersionCodename='([^']+)'");

  final _regExpValue = RegExp(r"'([^']+)'");

  Future<bool> aaptInit(String? aaptPath) async {
    // final String? androidHome = Platform.environment['ANDROID_SDK_ROOT'];
    // if ((androidHome ?? '').isEmpty) {
    //   throw Exception('Missing `ANDROID_HOME` environment variable.');
    // }
    // final buildToolsDir = Directory(p.join(androidHome!, 'build-tools'));
    // final aaptDir = buildToolsDir.listSync().last.path;
    // _aaptPath = p.join(aaptDir, aaptApp);
    if (aaptPath == null) return false;
    final aapt = File(aaptPath);
    if (await aapt.exists()) {
      _aaptPath = aaptPath;
      return true;
    } else {
      return false;
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
    } catch(e) {
      return null;
    }
  }

  Future<ApkInfo?> parseFile(File file) async {
    final aaptPath = _aaptPath;
    if ((aaptPath ?? '').isEmpty) {
      throw Exception('aapt not found');
    }
    final ProcessResult processResult = await Process.run(
      aaptPath!,
      ['dump', 'badging', file.path],
    );

    final String resultString = processResult.stdout;
    // logger.d('parse >> $resultString');

    final rawDataList = _splitter.convert(resultString);

    String? applicationId;
    String? versionCode;
    String? versionName;
    String? platformBuildVersionName;
    String? platformBuildVersionCode;
    String? compileSdkVersion;
    String? compileSdkVersionCodename;
    String? sdkVersion;
    String? targetSdkVersion;
    String? applicationLabel;

    for (final row in rawDataList) {
      _logger.d('row >> $row');
      final arr = row.split(':');
      if (arr.length >= 2) {
        final data = arr[1];
        switch (arr[0]) {
          case 'package':
            final regExpMatch1 = _regExpPackage.firstMatch(data);
            applicationId = regExpMatch1?.group(1);
            versionCode = regExpMatch1?.group(2);
            versionName = regExpMatch1?.group(3);
            platformBuildVersionName = regExpMatch1?.group(4);
            platformBuildVersionCode = regExpMatch1?.group(5);
            compileSdkVersion = regExpMatch1?.group(6);
            compileSdkVersionCodename = regExpMatch1?.group(7);
            break;
          case 'sdkVersion':
            final regExpMatch1 = _regExpValue.firstMatch(data);
            sdkVersion = regExpMatch1?.group(1);
            break;
          case 'targetSdkVersion':
            final regExpMatch1 = _regExpValue.firstMatch(data);
            targetSdkVersion = regExpMatch1?.group(1);
            break;
          case 'application-label':
            final regExpMatch1 = _regExpValue.firstMatch(data);
            applicationLabel = regExpMatch1?.group(1);
            break;
        }
      } else {
        _logger.d('error row >> $row');
      }
    }
    return ApkInfo(
      uuid: uuidInst.v4(),
      file: file,
      applicationId: applicationId,
      versionCode: versionCode,
      versionName: versionName,
      platformBuildVersionName: platformBuildVersionName,
      platformBuildVersionCode: platformBuildVersionCode,
      compileSdkVersion: compileSdkVersion,
      compileSdkVersionCodename: compileSdkVersionCodename,
      sdkVersion: sdkVersion,
      targetSdkVersion: targetSdkVersion,
      applicationLabel: applicationLabel,
    );
  }

  Future<List<ApkInfo>?> parseFiles(Iterable<File> files) async {
    final list = <ApkInfo>[];
    for (var el in files) {
      final info = await parseFile(el);
      if (info != null) {
        list.add(info);
      }
    }
    return list;
  }
}
