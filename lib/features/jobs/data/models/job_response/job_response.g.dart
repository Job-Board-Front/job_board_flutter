// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobResponse _$JobResponseFromJson(Map<String, dynamic> json) => JobResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => Job.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$JobResponseToJson(JobResponse instance) =>
    <String, dynamic>{'data': instance.data};
