import 'apk_info.dart';
import 'apk_keys.dart';

class ApkUtil {
  static String fromApkInfo(final String? apkKey, final ApkInfo? apkInfo) {
    String? data;
    switch(apkKey){
      case ApkKeys.apkApplicationId: data = apkInfo?.applicationId;
      case ApkKeys.apkVersionCode: data = apkInfo?.versionCode;
      case ApkKeys.apkVersionName: data = apkInfo?.versionName;
      case ApkKeys.apkPlatformBuildVersionName: data = apkInfo?.platformBuildVersionName;
      case ApkKeys.apkPlatformBuildVersionCode: data = apkInfo?.platformBuildVersionCode;
      case ApkKeys.apkCompileSdkVersion: data = apkInfo?.compileSdkVersion;
      case ApkKeys.apkCompileSdkVersionCodename: data = apkInfo?.compileSdkVersionCodename;
      case ApkKeys.apkSdkVersion: data = apkInfo?.sdkVersion;
      case ApkKeys.apkTargetSdkVersion: data = apkInfo?.targetSdkVersion;
      case ApkKeys.apkApplicationLabel: data = apkInfo?.applicationLabel;
    }
    return data ?? '';
  }
}