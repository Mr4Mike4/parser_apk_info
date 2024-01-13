import 'dart:io';

import 'package:parser_apk_info/repository/aapt_util.dart';
import 'package:parser_apk_info/repository/apk_util.dart';
import 'package:parser_apk_info/repository/disable_logger.dart';
import 'package:parser_apk_info/repository/parser_apk_info_aapt.dart';
import 'package:path/path.dart' as p;

String getAaptApp() {
  final String? androidHome = Platform.environment['ANDROID_SDK_ROOT'];
  if ((androidHome ?? '').isEmpty) {
    throw Exception('Missing `ANDROID_SDK_ROOT` environment variable.');
  }
  return Directory(p.join(androidHome!, 'build-tools')).listSync().last.path;
}

void printRow(String key, String? value){
  print('$key --> $value');
}

Future<void> main() async {
  final parserApkInfo = ParserApkInfoAapt(DisableLogger());

  final aaptDirPath = getAaptApp();
  final aaptPath = await AaptUtil.getAaptApp(aaptDirPath);
  if (aaptPath == null) {
    throw Exception('aapt2 not found!');
  }
  await parserApkInfo.aaptInit(aaptPath);

  final apkFile = File(r'file_name.apk');
  if (await apkFile.exists()) {
    final apkInfo = await parserApkInfo.parseFile(apkFile);
    if (apkInfo != null) {
      printRow('file', apkInfo.file.path);
      printRow('applicationLabel', apkInfo.applicationLabel);
      printRow('applicationId', apkInfo.applicationId);
      printRow('versionCode', apkInfo.versionCode);
      printRow('versionName', apkInfo.versionName);
      printRow('platformBuildVersionName', apkInfo.platformBuildVersionName);
      printRow('platformBuildVersionCode', apkInfo.platformBuildVersionCode);
      printRow('compileSdkVersion', apkInfo.compileSdkVersion);
      printRow('compileSdkVersionCodename', apkInfo.compileSdkVersionCodename);
      printRow('minSdkVersion', apkInfo.minSdkVersion);
      printRow('targetSdkVersion', apkInfo.targetSdkVersion);
      printRow('applicationLabels', ApkUtil.mapToStr(apkInfo.applicationLabels));
      printRow('usesPermissions', apkInfo.usesPermissions?.join(', '));
      printRow('nativeCodes', apkInfo.nativeCodes?.join(', '));
      printRow('locales', apkInfo.locales?.join(', '));
    }
  } else {
    print('${apkFile.path} not found!');
  }
}
