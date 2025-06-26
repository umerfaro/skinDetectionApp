import 'package:hive/hive.dart';

part 'skin_report.g.dart';

@HiveType(typeId: 0)
class SkinReport extends HiveObject {
  @HiveField(0)
  final String imagePath;

  @HiveField(1)
  final String date;

  @HiveField(2)
  final String diagnosis;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final dynamic rawOutput;

  SkinReport({
    required this.imagePath,
    required this.date,
    required this.diagnosis,
    required this.description,
    required this.rawOutput,
  });
}
