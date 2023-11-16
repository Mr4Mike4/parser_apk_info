import 'dart:convert';
import 'dart:io';

import 'package:parser_apk_info/model/apk_info.dart';
import 'package:parser_apk_info/model/apk_keys.dart';
import 'package:parser_apk_info/repository/apk_util.dart';
import 'package:parser_apk_info/repository/parser_apk_info_aapt.dart';
import 'package:parser_apk_info/repository/print_logger.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late ParserApkInfoAapt _parserApkInfo;

  ApkInfo? _apkInfo;

  setUp(() async {
    _parserApkInfo = ParserApkInfoAapt(PrintLogger());
    final String? androidHome = Platform.environment['ANDROID_SDK_ROOT'];
    if ((androidHome ?? '').isEmpty) {
      throw Exception('Missing `ANDROID_HOME` environment variable.');
    }
    final buildToolsDir = Directory(p.join(androidHome!, 'build-tools'));
    final aaptPath = buildToolsDir.listSync().last.path;

    _parserApkInfo.aaptInit(aaptPath);

    final testDataFile = File(p.join('test_resources', 'test_data_rus.txt'));
    final dataString =await testDataFile.readAsString(encoding: utf8);

    _apkInfo = await _parserApkInfo.parseString(testDataFile, dataString);
  });

  test('ApkUtil.fromApkInfo test', () async {
    expect(ApkUtil.fromApkInfo(ApkKeys.apkApplicationId, _apkInfo), 'ru.csa');
    expect(ApkUtil.fromApkInfo(ApkKeys.apkVersionCode, _apkInfo), '10');
    expect(ApkUtil.fromApkInfo(ApkKeys.apkVersionName, _apkInfo), '0.8.4-dev');
    expect(ApkUtil.fromApkInfo(ApkKeys.apkPlatformBuildVersionName, _apkInfo), '14');
    expect(ApkUtil.fromApkInfo(ApkKeys.apkPlatformBuildVersionCode, _apkInfo), '34');
    expect(ApkUtil.fromApkInfo(ApkKeys.apkCompileSdkVersion, _apkInfo), '34');
    expect(ApkUtil.fromApkInfo(ApkKeys.apkCompileSdkVersionCodename, _apkInfo), '14');
    expect(ApkUtil.fromApkInfo(ApkKeys.apkSdkVersion, _apkInfo), '26');
    expect(ApkUtil.fromApkInfo(ApkKeys.apkTargetSdkVersion, _apkInfo), '34');
    expect(ApkUtil.fromApkInfo(ApkKeys.apkApplicationLabel, _apkInfo), 'ЦСА');
    expect(ApkUtil.fromApkInfo('gfgfgfg', _apkInfo), isEmpty);
  });
}