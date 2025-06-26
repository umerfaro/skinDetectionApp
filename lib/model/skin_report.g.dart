// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skin_report.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SkinReportAdapter extends TypeAdapter<SkinReport> {
  @override
  final int typeId = 0;

  @override
  SkinReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SkinReport(
      imagePath: fields[0] as String,
      date: fields[1] as String,
      diagnosis: fields[2] as String,
      description: fields[3] as String,
      rawOutput: fields[4] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, SkinReport obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.imagePath)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.diagnosis)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.rawOutput);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkinReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
