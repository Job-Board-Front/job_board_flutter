import 'package:json_annotation/json_annotation.dart';
import '../job_model.dart';

part 'job_response.g.dart';

@JsonSerializable()
class JobResponse {
  final List<Job> data;

  JobResponse({required this.data});

  factory JobResponse.fromJson(Map<String, dynamic> json) =>
      _$JobResponseFromJson(json);
  Map<String, dynamic> toJson() => _$JobResponseToJson(this);
}
