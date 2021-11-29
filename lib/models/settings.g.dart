// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      json['enableProxy'] as bool,
      json['httpProxyUrl'] as String,
      json['isLightTheme'] as bool,
      json['imageSource'] as String,
      json['previewQuality'] as bool,
      json['scaleQuality'] as bool,
      json['enableBrowsingHistory'] as bool,
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'enableProxy': instance.enableProxy,
      'httpProxyUrl': instance.httpProxyUrl,
      'isLightTheme': instance.isLightTheme,
      'imageSource': instance.imageSource,
      'previewQuality': instance.previewQuality,
      'scaleQuality': instance.scaleQuality,
      'enableBrowsingHistory': instance.enableBrowsingHistory,
    };
