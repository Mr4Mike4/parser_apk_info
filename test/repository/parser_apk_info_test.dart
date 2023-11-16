import 'dart:convert';
import 'dart:io';

import 'package:parser_apk_info/repository/parser_apk_info_aapt.dart';
import 'package:parser_apk_info/repository/print_logger.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late ParserApkInfoAapt _parserApkInfo;

  // String? _aaptPath;

  setUp(() {
  _parserApkInfo = ParserApkInfoAapt(PrintLogger());
    final String? androidHome = Platform.environment['ANDROID_SDK_ROOT'];
    if ((androidHome ?? '').isEmpty) {
      throw Exception('Missing `ANDROID_HOME` environment variable.');
    }
    final buildToolsDir = Directory(p.join(androidHome!, 'build-tools'));
    final aaptPath = buildToolsDir.listSync().last.path;

  _parserApkInfo.aaptInit(aaptPath);
  });

  test('aaptInit test', () async {

    final String? androidHome = Platform.environment['ANDROID_SDK_ROOT'];

    expect(androidHome, isNotNull);
    expect(androidHome, isNotEmpty);
    final buildToolsDir = Directory(p.join(androidHome!, 'build-tools'));
    final aaptDir = buildToolsDir.listSync().last.path;

    final isInit = await _parserApkInfo.aaptInit(aaptDir);

    expect(isInit, isTrue);
  });

  test('parseString test', () async {

    final testDataFile = File(p.join('test_resources', 'test_data_rus.txt'));
    final dataString =await testDataFile.readAsString(encoding: utf8);

    final apkInfo = await _parserApkInfo.parseString(testDataFile, dataString);

    // expect(apkInfo, isNotNull);

    expect(apkInfo?.file.path, testDataFile.path);
    expect(apkInfo?.applicationId, 'ru.csa');
    expect(apkInfo?.versionCode, '10');
    expect(apkInfo?.versionName, '0.8.4-dev');
    expect(apkInfo?.platformBuildVersionName, '14');
    expect(apkInfo?.platformBuildVersionCode, '34');
    expect(apkInfo?.compileSdkVersion, '34');
    expect(apkInfo?.compileSdkVersionCodename, '14');
    expect(apkInfo?.sdkVersion, '26');
    expect(apkInfo?.targetSdkVersion, '34');
    expect(apkInfo?.applicationLabel, 'ЦСА');
  });
}
