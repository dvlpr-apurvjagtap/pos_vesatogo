// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderAdapter extends TypeAdapter<Order> {
  @override
  final int typeId = 2;

  @override
  Order read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Order(
      id: fields[0] as String,
      items: (fields[1] as List).cast<OrderItem>(),
      subtotal: fields[2] as double,
      tax: fields[3] as double,
      discount: fields[4] as double,
      tip: fields[5] as double,
      total: fields[6] as double,
      status: fields[7] as String,
      paymentMethod: fields[8] as String,
      orderType: fields[9] as String,
      customer: fields[10] as Customer?,
      notes: fields[11] as String,
      tableNumber: fields[12] as String,
      createdAt: fields[13] as DateTime,
      isCredit: fields[14] as bool,
      isComplementary: fields[15] as bool,
      tokens: (fields[16] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.items)
      ..writeByte(2)
      ..write(obj.subtotal)
      ..writeByte(3)
      ..write(obj.tax)
      ..writeByte(4)
      ..write(obj.discount)
      ..writeByte(5)
      ..write(obj.tip)
      ..writeByte(6)
      ..write(obj.total)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.paymentMethod)
      ..writeByte(9)
      ..write(obj.orderType)
      ..writeByte(10)
      ..write(obj.customer)
      ..writeByte(11)
      ..write(obj.notes)
      ..writeByte(12)
      ..write(obj.tableNumber)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.isCredit)
      ..writeByte(15)
      ..write(obj.isComplementary)
      ..writeByte(16)
      ..write(obj.tokens);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
