// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      json['isLightTheme'] as bool,
      json['imageSource'] as String,
      json['previewQuality'] as bool,
      json['scaleQuality'] as bool,
      json['enableBrowsingHistory'] as bool,
      json['language'] as String,
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'isLightTheme': instance.isLightTheme,
      'imageSource': instance.imageSource,
      'previewQuality': instance.previewQuality,
      'scaleQuality': instance.scaleQuality,
      'enableBrowsingHistory': instance.enableBrowsingHistory,
      'language': instance.language,
    };
