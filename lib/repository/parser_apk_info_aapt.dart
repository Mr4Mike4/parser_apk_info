import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:parser_apk_info/parser_apk_info.dart';

import '../model/aapt_keys.dart';

class ParserApkInfoAapt extends ParserApkInfo {
  ParserApkInfoAapt(this._logger);

  final Logger _logger;

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
    if (aaptPath == null) return false;
    final aapt = File(aaptPath);
    if (await aapt.exists()) {
      _aaptPath = aaptPath;
      return true;
    } else {
      return false;
    }
  }

  List<String> _dataFromString(String data) {
    final regExpMatch1 = _regExpValue.allMatches(data);
    return regExpMatch1
        .map((e) => e.group(1))
        .where((e) => e != null)
        .map((e) => e!)
        .toList(growable: false);
  }

  List<T>? _toUnmodifiableList<T>(List<T>? list){
    if(list == null || list.isEmpty) return null;
    return List.unmodifiable(list);
  }

  Map<K, V>? _toUnmodifiableMap<K, V>(Map<K, V>? map){
    if(map == null || map.isEmpty) return null;
    return Map.unmodifiable(map);
  }

  @override
  @visibleForTesting
  Future<ApkInfo?> parseString(final File file, final String dataString) async {
    // logger.d('parse >> $resultString');

    final rawDataList = _splitter.convert(dataString);

    String? applicationId;
    String? versionCode;
    String? versionName;
    String? platformBuildVersionName;
    String? platformBuildVersionCode;
    String? compileSdkVersion;
    String? compileSdkVersionCodename;
    String? minSdkVersion;
    String? targetSdkVersion;
    String? applicationLabel;
    Map<String, String>? applicationLabels = {};
    List<String>? usesPermissions = [];
    List<String>? nativeCodes;
    List<String>? locales;

    for (final row in rawDataList) {
      _logger.d('row >> $row');
      final arr = row.split(':');
      if (arr.length >= 2) {
        final key = arr[0];
        final data = arr[1];
        if (key == AaptKeys.package) {
          final regExpMatch1 = _regExpPackage.firstMatch(data);
          applicationId = regExpMatch1?.group(1);
          versionCode = regExpMatch1?.group(2);
          versionName = regExpMatch1?.group(3);
          platformBuildVersionName = regExpMatch1?.group(4);
          platformBuildVersionCode = regExpMatch1?.group(5);
          compileSdkVersion = regExpMatch1?.group(6);
          compileSdkVersionCodename = regExpMatch1?.group(7);
        } else if (key == AaptKeys.sdkVersion) {
          final regExpMatch1 = _regExpValue.firstMatch(data);
          minSdkVersion = regExpMatch1?.group(1);
        } else if (key == AaptKeys.targetSdkVersion) {
          final regExpMatch1 = _regExpValue.firstMatch(data);
          targetSdkVersion = regExpMatch1?.group(1);
        } else if (key == AaptKeys.applicationLabel) {
          final regExpMatch1 = _regExpValue.firstMatch(data);
          applicationLabel = regExpMatch1?.group(1);
        } else if (key.contains(AaptKeys.applicationLabel)) {
          final lang = key.substring(AaptKeys.applicationLabel.length + 1);
          final regExpMatch1 = _regExpValue.firstMatch(data);
          final label = regExpMatch1?.group(1);
          if (label != null) {
            applicationLabels[lang] = label ?? '';
          }
        } else if (key.contains(AaptKeys.applicationLabel)) {
          final lang = key.substring(AaptKeys.applicationLabel.length + 1);
          final regExpMatch1 = _regExpValue.firstMatch(data);
          final label = regExpMatch1?.group(1);
          if (label != null) {
            applicationLabels[lang] = label ?? '';
          }
        } else if (key.contains(AaptKeys.usesPermission)) {
          final regExpMatch1 = _regExpValue.firstMatch(data);
          final permission = regExpMatch1?.group(1);
          if (permission != null) {
            usesPermissions.add(permission);
          }
        } else if (key.contains(AaptKeys.nativeCode)) {
          nativeCodes = _dataFromString(data);
        } else if (key.contains(AaptKeys.locales)) {
          locales = _dataFromString(data);
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
      minSdkVersion: minSdkVersion,
      targetSdkVersion: targetSdkVersion,
      applicationLabel: applicationLabel,
      applicationLabels: _toUnmodifiableMap(applicationLabels),
      usesPermissions: _toUnmodifiableList(usesPermissions),
      nativeCodes: _toUnmodifiableList(nativeCodes),
      locales: _toUnmodifiableList(locales),
    );
  }

  @override
  Future<ApkInfo?> parseFile(File file) async {
    final aaptPath = _aaptPath;
    if ((aaptPath ?? '').isEmpty) {
      throw Exception('aapt not found');
    }
    final ProcessResult processResult = await Process.run(
      aaptPath!,
      ['dump', 'badging', file.path],
      stdoutEncoding: utf8,
      stderrEncoding: utf8,
    );
    final String resultString = processResult.stdout;
    return parseString(file, resultString);
  }

  @override
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
