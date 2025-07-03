// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skin_report_enhanced.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SkinReportEnhancedAdapter extends TypeAdapter<SkinReportEnhanced> {
  @override
  final int typeId = 1;

  @override
  SkinReportEnhanced read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SkinReportEnhanced(
      id: fields[0] as String,
      imagePath: fields[1] as String,
      createdAt: fields[2] as DateTime,
      updatedAt: fields[3] as DateTime?,
      diagnosis: fields[4] as String,
      description: fields[5] as String,
      confidence: fields[6] as double?,
      severity: fields[7] as String?,
      recommendations: (fields[8] as List).cast<String>(),
      riskLevel: fields[9] as String?,
      followUp: fields[10] as String?,
      rawOutput: (fields[11] as Map?)?.cast<String, dynamic>(),
      isFavorite: fields[12] as bool,
      notes: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SkinReportEnhanced obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.diagnosis)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.confidence)
      ..writeByte(7)
      ..write(obj.severity)
      ..writeByte(8)
      ..write(obj.recommendations)
      ..writeByte(9)
      ..write(obj.riskLevel)
      ..writeByte(10)
      ..write(obj.followUp)
      ..writeByte(11)
      ..write(obj.rawOutput)
      ..writeByte(12)
      ..write(obj.isFavorite)
      ..writeByte(13)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkinReportEnhancedAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
