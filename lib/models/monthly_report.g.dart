// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_report.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MonthlyReportAdapter extends TypeAdapter<MonthlyReport> {
  @override
  final int typeId = 4;

  @override
  MonthlyReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MonthlyReport(
      month: fields[0] as DateTime,
      totalIncome: fields[1] as double,
      totalExpense: fields[2] as double,
      balance: fields[3] as double,
      notes: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MonthlyReport obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.month)
      ..writeByte(1)
      ..write(obj.totalIncome)
      ..writeByte(2)
      ..write(obj.totalExpense)
      ..writeByte(3)
      ..write(obj.balance)
      ..writeByte(4)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
