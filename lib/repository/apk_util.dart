import 'dart:io';

import '../model/apk_info.dart';
import '../model/apk_keys.dart';

class ApkUtil {
  static String mapToStr(Map<String, String>? map) {
    if (map == null) return '';
    var sb = StringBuffer();
    final lineTerminator = Platform.lineTerminator;
    map.entries.forEach((el) {
      sb
        ..write(el.key)
        ..write(' => ')
        ..write(el.value)
        ..write(lineTerminator);
    });
    return sb.toString();
  }

  static String fromApkInfo(final String? apkKey, final ApkInfo? apkInfo) {
    String? data;
    switch (apkKey) {
      case ApkKeys.apkApplicationId:
        data = apkInfo?.applicationId;
      case ApkKeys.apkVersionCode:
        data = apkInfo?.versionCode;
      case ApkKeys.apkVersionName:
        data = apkInfo?.versionName;
      case ApkKeys.apkPlatformBuildVersionName:
        data = apkInfo?.platformBuildVersionName;
      case ApkKeys.apkPlatformBuildVersionCode:
        data = apkInfo?.platformBuildVersionCode;
      case ApkKeys.apkCompileSdkVersion:
        data = apkInfo?.compileSdkVersion;
      case ApkKeys.apkCompileSdkVersionCodename:
        data = apkInfo?.compileSdkVersionCodename;
      case ApkKeys.apkMinSdkVersion:
        data = apkInfo?.minSdkVersion;
      case ApkKeys.apkTargetSdkVersion:
        data = apkInfo?.targetSdkVersion;
      case ApkKeys.apkApplicationLabel:
        data = apkInfo?.applicationLabel;
      case ApkKeys.apkApplicationLabels:
        data = mapToStr(apkInfo?.applicationLabels);
      case ApkKeys.apkUsesPermission:
        data = apkInfo?.usesPermissions?.join(Platform.lineTerminator);
      case ApkKeys.apkNativeCode:
        data = apkInfo?.nativeCodes?.join(', ');
      case ApkKeys.apkLocales:
        data = apkInfo?.locales?.join(', ');
    }
    return data ?? '';
  }
}
