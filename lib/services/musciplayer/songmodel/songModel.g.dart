// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'songModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Song _$SongFromJson(Map<String, dynamic> json) => Song()
  ..trackName = json['trackName'] ?? ''
  ..photo = json['artworkUrl100'] ?? ''
  ..songurl = json['previewUrl'] ?? ''
  ..collection = json['collectionName'] ?? '';

Map<String, dynamic> _$SongToJson(Song instance) => <String, dynamic>{
      'trackName': instance.trackName,
      'artworkUrl100': instance.photo,
      'previewUrl': instance.songurl,
      'collectionName': instance.collection,
    };
