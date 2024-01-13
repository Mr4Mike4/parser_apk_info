import 'dart:convert';
import 'dart:io';

import 'package:parser_apk_info/repository/parser_apk_info_aapt.dart';
import 'package:parser_apk_info/repository/print_logger.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late ParserApkInfoAapt _parserApkInfo;

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

  test('parseString test_rus', () async {
    final testDataFile = File(p.join('test_resources', 'test_data_rus.txt'));
    final dataString = await testDataFile.readAsString(encoding: utf8);

    final apkInfo = await _parserApkInfo.parseString(testDataFile, dataString);

    expect(apkInfo, isNotNull);

    if (apkInfo != null) {
      final labelsRus = {
        'ru': 'ПРИЛОЖ',
      };
      final usesPermissionRus = [
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
      ];
      final nativeCodeRus = ['arm64-v8a', 'armeabi-v7a', 'x86', 'x86_64'];
      final localesRus = ['--_--', 'ru'];

      expect(apkInfo.file.path, testDataFile.path);
      expect(apkInfo.applicationId, 'ru.app');
      expect(apkInfo.versionCode, '10');
      expect(apkInfo.versionName, '0.8.4-dev');
      expect(apkInfo.platformBuildVersionName, '14');
      expect(apkInfo.platformBuildVersionCode, '34');
      expect(apkInfo.compileSdkVersion, '34');
      expect(apkInfo.compileSdkVersionCodename, '14');
      expect(apkInfo.minSdkVersion, '26');
      expect(apkInfo.targetSdkVersion, '34');
      expect(apkInfo.applicationLabel, 'APP');
      expect(apkInfo.applicationLabels, labelsRus);
      expect(apkInfo.usesPermissions, usesPermissionRus);
      expect(apkInfo.nativeCodes, nativeCodeRus);
      expect(apkInfo.locales, localesRus);
    }
  });

  test('parseString test', () async {
    final testDataFile = File(p.join('test_resources', 'test_data.txt'));
    final dataString = await testDataFile.readAsString(encoding: utf8);

    final apkInfo = await _parserApkInfo.parseString(testDataFile, dataString);

    expect(apkInfo, isNotNull);

    if (apkInfo != null) {
      final labels = {
        'af': 'Amaze',
        'am': 'Amaze',
        'ar': 'Amaze',
        'as': 'Amaze',
        'as-IN': 'Amaze',
        'ast-ES': 'Amaze',
        'az': 'Amaze',
        'az-AZ': 'Amaze',
        'be': 'Amaze',
        'be-BY': 'Amaze',
        'bg': 'Amaze',
        'bn': 'Amaze',
        'bn-BD': 'Amaze',
        'bs': 'Amaze',
        'ca': 'Amaze',
        'cs': 'Amaze',
        'da': 'Amaze',
        'de': 'Amaze',
        'el': 'Amaze',
        'en-AU': 'Amaze',
        'en-CA': 'Amaze',
        'en-GB': 'Amaze',
        'en-IN': 'Amaze',
        'en-PT': 'Amaze',
        'en-XC': 'Amaze',
        'eo': 'Amaze',
        'es': 'Amaze',
        'es-419': 'Amaze',
        'es-CO': 'Amaze',
        'es-MX': 'Amaze',
        'es-US': 'Amaze',
        'et': 'Amaze',
        'et-EE': 'Amaze',
        'eu': 'Amaze',
        'eu-ES': 'Amaze',
        'fa': 'Amaze',
        'fi': 'Amaze',
        'fr': 'Amaze',
        'fr-CA': 'Amaze',
        'gl': 'Amaze',
        'gl-ES': 'Amaze',
        'gu': 'Amaze',
        'gu-IN': 'Amaze',
        'he': 'Amaze',
        'hi': 'Amaze',
        'hr': 'Amaze',
        'hu': 'Amaze',
        'hy': 'Amaze',
        'hy-AM': 'Amaze',
        'id': 'Amaze',
        'in': 'Amaze',
        'is': 'Amaze',
        'is-IS': 'Amaze',
        'it': 'Amaze',
        'iw': 'Amaze',
        'ja': 'Amaze',
        'ka': 'Amaze',
        'ka-GE': 'Amaze',
        'kk': 'Amaze',
        'kk-KZ': 'Amaze',
        'km': 'Amaze',
        'km-KH': 'Amaze',
        'kn': 'Amaze',
        'kn-IN': 'Amaze',
        'ko': 'Amaze',
        'ku': 'Amaze',
        'ky': 'Amaze',
        'ky-KG': 'Amaze',
        'lb': 'Amaze',
        'lo': 'Amaze',
        'lo-LA': 'Amaze',
        'lt': 'Amaze',
        'lv': 'Amaze',
        'mk': 'Amaze',
        'mk-MK': 'Amaze',
        'ml': 'Amaze',
        'ml-IN': 'Amaze',
        'mn': 'Amaze',
        'mn-MN': 'Amaze',
        'mr': 'Amaze',
        'mr-IN': 'Amaze',
        'ms': 'Amaze',
        'ms-MY': 'Amaze',
        'my': 'Amaze',
        'my-MM': 'Amaze',
        'nb': 'Amaze',
        'ne': 'Amaze',
        'ne-NP': 'Amaze',
        'nl': 'Amaze',
        'or': 'Amaze',
        'or-IN': 'Amaze',
        'pa': 'Amaze',
        'pa-IN': 'Amaze',
        'pl': 'Amaze',
        'pt': 'Amaze',
        'pt-BR': 'Amaze',
        'pt-PT': 'Amaze',
        'ro': 'Amaze',
        'ru': 'Amaze',
        'si': 'Amaze',
        'si-LK': 'Amaze',
        'sk': 'Amaze',
        'sl': 'Amaze',
        'sq': 'Amaze',
        'sq-AL': 'Amaze',
        'sr': 'Amaze',
        'sr-Latn': 'Amaze',
        'sv': 'Amaze',
        'sv-SE': 'Amaze',
        'sw': 'Amaze',
        'ta': 'Amaze',
        'ta-IN': 'Amaze',
        'te': 'Amaze',
        'te-IN': 'Amaze',
        'th': 'Amaze',
        'tl': 'Amaze',
        'tr': 'Amaze',
        'ug': 'Amaze',
        'uk': 'Amaze',
        'ur': 'Amaze',
        'ur-PK': 'Amaze',
        'uz': 'Amaze',
        'uz-UZ': 'Amaze',
        'vi': 'Amaze',
        'zh-CN': 'Amaze',
        'zh-HK': 'Amaze',
        'zh-TW': 'Amaze',
        'zu': 'Amaze',
      };
      final usesPermission = [
        'android.permission.WAKE_LOCK',
        'android.permission.ACCESS_WIFI_STATE',
        'android.permission.ACCESS_NETWORK_STATE',
        'android.permission.WRITE_EXTERNAL_STORAGE',
        'com.android.launcher.permission.INSTALL_SHORTCUT',
        'android.permission.INTERNET',
        'com.amaze.cloud.permission.ACCESS_PROVIDER',
        'android.permission.USE_FINGERPRINT',
        'android.permission.REQUEST_INSTALL_PACKAGES',
        'android.permission.FOREGROUND_SERVICE',
        'android.permission.REQUEST_DELETE_PACKAGES',
        'android.permission.MANAGE_EXTERNAL_STORAGE',
        'android.permission.QUERY_ALL_PACKAGES',
        'android.permission.READ_EXTERNAL_STORAGE',
      ];
      final nativeCode = ['arm64-v8a', 'armeabi-v7a', 'x86', 'x86_64'];
      final locales = [
        '--_--',
        'af',
        'am',
        'ar',
        'as',
        'as-IN',
        'ast-ES',
        'az',
        'az-AZ',
        'be',
        'be-BY',
        'bg',
        'bn',
        'bn-BD',
        'bs',
        'ca',
        'cs',
        'da',
        'de',
        'el',
        'en-AU',
        'en-CA',
        'en-GB',
        'en-IN',
        'en-PT',
        'en-XC',
        'eo',
        'es',
        'es-419',
        'es-CO',
        'es-MX',
        'es-US',
        'et',
        'et-EE',
        'eu',
        'eu-ES',
        'fa',
        'fi',
        'fr',
        'fr-CA',
        'gl',
        'gl-ES',
        'gu',
        'gu-IN',
        'he',
        'hi',
        'hr',
        'hu',
        'hy',
        'hy-AM',
        'id',
        'in',
        'is',
        'is-IS',
        'it',
        'iw',
        'ja',
        'ka',
        'ka-GE',
        'kk',
        'kk-KZ',
        'km',
        'km-KH',
        'kn',
        'kn-IN',
        'ko',
        'ku',
        'ky',
        'ky-KG',
        'lb',
        'lo',
        'lo-LA',
        'lt',
        'lv',
        'mk',
        'mk-MK',
        'ml',
        'ml-IN',
        'mn',
        'mn-MN',
        'mr',
        'mr-IN',
        'ms',
        'ms-MY',
        'my',
        'my-MM',
        'nb',
        'ne',
        'ne-NP',
        'nl',
        'or',
        'or-IN',
        'pa',
        'pa-IN',
        'pl',
        'pt',
        'pt-BR',
        'pt-PT',
        'ro',
        'ru',
        'si',
        'si-LK',
        'sk',
        'sl',
        'sq',
        'sq-AL',
        'sr',
        'sr-Latn',
        'sv',
        'sv-SE',
        'sw',
        'ta',
        'ta-IN',
        'te',
        'te-IN',
        'th',
        'tl',
        'tr',
        'ug',
        'uk',
        'ur',
        'ur-PK',
        'uz',
        'uz-UZ',
        'vi',
        'zh-CN',
        'zh-HK',
        'zh-TW',
        'zu',
      ];

      expect(apkInfo.file.path, testDataFile.path);
      expect(apkInfo.applicationId, 'com.amaze.filemanager');
      expect(apkInfo.versionCode, '117');
      expect(apkInfo.versionName, '3.8.4');
      expect(apkInfo.platformBuildVersionName, '12');
      expect(apkInfo.platformBuildVersionCode, '31');
      expect(apkInfo.compileSdkVersion, '31');
      expect(apkInfo.compileSdkVersionCodename, '12');
      expect(apkInfo.minSdkVersion, '14');
      expect(apkInfo.targetSdkVersion, '31');
      expect(apkInfo.applicationLabel, 'Amaze');
      expect(apkInfo.applicationLabels, labels);
      expect(apkInfo.usesPermissions, usesPermission);
      expect(apkInfo.nativeCodes, nativeCode);
      expect(apkInfo.locales, locales);
    }
  });
}
