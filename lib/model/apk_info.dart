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
    this.sdkVersion,
    this.targetSdkVersion,
    this.applicationLabel,
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
  final String? sdkVersion;
  final String? targetSdkVersion;
  final String? applicationLabel;
}
