import 'dart:convert';
import 'dart:io';

import 'package:parser_apk_info/model/apk_keys.dart';
import 'package:parser_apk_info/repository/apk_util.dart';
import 'package:parser_apk_info/repository/parser_apk_info_aapt.dart';
import 'package:parser_apk_info/repository/print_logger.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late ParserApkInfoAapt _parserApkInfo;

  setUp(() async {
    _parserApkInfo = ParserApkInfoAapt(PrintLogger());
    final String? androidHome = Platform.environment['ANDROID_SDK_ROOT'];
    if ((androidHome ?? '').isEmpty) {
      throw Exception('Missing `ANDROID_HOME` environment variable.');
    }
    final buildToolsDir = Directory(p.join(androidHome!, 'build-tools'));
    final aaptPath = buildToolsDir.listSync().last.path;

    _parserApkInfo.aaptInit(aaptPath);
  });
  final lineTerminator = Platform.lineTerminator;
  final labelsRus = 'ru => ПРИЛОЖ$lineTerminator';
  final usesPermission = [
    'android.permission.INTERNET',
    'android.permission.ACCESS_FINE_LOCATION',
    'android.permission.ACCESS_COARSE_LOCATION',
    'android.permission.ACCESS_BACKGROUND_LOCATION',
    'android.permission.ACCESS_LOCATION_EXTRA_COMMANDS',
    'android.permission.ACCESS_NETWORK_STATE',
    'android.permission.FOREGROUND_SERVICE',
    'android.permission.WAKE_LOCK',
    'android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
    'android.permission.POST_NOTIFICATIONS',
    'android.permission.CAMERA',
    'android.permission.VIBRATE',
    'android.permission.RECEIVE_BOOT_COMPLETED',
    'ru.csa.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION',
  ].join(lineTerminator);
  final nativeCode = ['arm64-v8a', 'armeabi-v7a', 'x86', 'x86_64']
      .join(', ');
  final locales = ['--_--', 'ru']
      .join(', ');

  test('ApkUtil.fromApkInfo test_rus', () async {
    final testDataFile = File(p.join('test_resources', 'test_data_rus.txt'));
    final dataString = await testDataFile.readAsString(encoding: utf8);

    final apkInfo = await _parserApkInfo.parseString(testDataFile, dataString);

    expect(ApkUtil.fromApkInfo(ApkKeys.apkApplicationId, apkInfo), 'ru.app');
    expect(ApkUtil.fromApkInfo(ApkKeys.apkVersionCode, apkInfo), '10');
    expect(ApkUtil.fromApkInfo(ApkKeys.apkVersionName, apkInfo), '0.8.4-dev');
    expect(ApkUtil.fromApkInfo(ApkKeys.apkPlatformBuildVersionName, apkInfo), '14');
    expect(ApkUtil.fromApkInfo(ApkKeys.apkPlatformBuildVersionCode, apkInfo), '34');
    expect(ApkUtil.fromApkInfo(ApkKeys.apkCompileSdkVersion, apkInfo), '34');
    expect(ApkUtil.fromApkInfo(ApkKeys.apkCompileSdkVersionCodename, apkInfo), '14');
    expect(ApkUtil.fromApkInfo(ApkKeys.apkMinSdkVersion, apkInfo), '26');
    expect(ApkUtil.fromApkInfo(ApkKeys.apkTargetSdkVersion, apkInfo), '34');
    expect(ApkUtil.fromApkInfo(ApkKeys.apkApplicationLabel, apkInfo), 'APP');
    expect(ApkUtil.fromApkInfo('gfgfgfg', apkInfo), isEmpty);
    expect(ApkUtil.fromApkInfo(ApkKeys.apkApplicationLabels, apkInfo), labelsRus);
    expect(ApkUtil.fromApkInfo(ApkKeys.apkUsesPermission, apkInfo), usesPermission);
    expect(ApkUtil.fromApkInfo(ApkKeys.apkNativeCode, apkInfo), nativeCode);
    expect(ApkUtil.fromApkInfo(ApkKeys.apkLocales, apkInfo), locales);
  });
}
