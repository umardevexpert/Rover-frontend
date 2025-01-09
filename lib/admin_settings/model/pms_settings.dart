import 'package:json_annotation/json_annotation.dart';
import 'package:master_kit/contracts/serializable.dart';

part 'pms_settings.g.dart';

@JsonSerializable(explicitToJson: true)
class PMSSettings implements Serializable {
  final String id;
  final String developerKey;
  final String customerKey;
  final String ipAddress;

  const PMSSettings({required this.customerKey, required this.id, required this.developerKey, required this.ipAddress});

  factory PMSSettings.fromJson(Map<String, dynamic> json) => _$PMSSettingsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PMSSettingsToJson(this);

  PMSSettings copyWith({
    String? id,
    String? developerKey,
    String? customerKey,
    String? ipAddress,
  }) {
    return PMSSettings(
      id: id ?? this.id,
      developerKey: developerKey ?? this.developerKey,
      customerKey: customerKey ?? this.customerKey,
      ipAddress: ipAddress ?? this.ipAddress,
    );
  }
}
