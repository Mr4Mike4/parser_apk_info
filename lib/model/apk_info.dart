import 'dart:io';

class ApkInfo {
  ApkInfo({
    required this.uuid,
    required this.file,
    this.applicationId,
    this.versionCode,
    this.versionName,
    this.platformBuildVersionName,
    this.platformBuildVersionCode,
    this.compileSdkVersion,
    this.compileSdkVersionCodename,
    this.minSdkVersion,
    this.targetSdkVersion,
    this.applicationLabel,
    this.applicationLabels,
    this.usesPermissions,
    this.nativeCodes,
    this.locales,
  });

  final String uuid;
  final File file;
  final String? applicationId;
  final String? versionCode;
  final String? versionName;
  final String? platformBuildVersionName;
  final String? platformBuildVersionCode;
  final String? compileSdkVersion;
  final String? compileSdkVersionCodename;
  final String? minSdkVersion;
  final String? targetSdkVersion;
  final String? applicationLabel;
  final Map<String, String>? applicationLabels;
  final List<String>? usesPermissions;
  final List<String>? nativeCodes;
  final List<String>? locales;
}
