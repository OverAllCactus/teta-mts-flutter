// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Chat _$$_ChatFromJson(Map<String, dynamic> json) => _$_Chat(
      title: json['title'] as String,
      lastMessage: json['lastMessage'] as String,
      timestamp: json['timestamp'] as int,
    );

Map<String, dynamic> _$$_ChatToJson(_$_Chat instance) => <String, dynamic>{
      'title': instance.title,
      'lastMessage': instance.lastMessage,
      'timestamp': instance.timestamp,
    };
