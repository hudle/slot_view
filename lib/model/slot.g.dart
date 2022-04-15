// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Slot _$SlotFromJson(Map<String, dynamic> json) {
  return Slot(
    json['available_count'] as int?,
    json['created_at'] as String?,
    json['end_time'] as String,
    json['facility_id'] as int?,
    json['id'] as String?,
    json['is_available'] as bool?,
    json['price'],
    json['base_price'],
    json['start_time'] as String,
    json['updated_at'] as String?,
    json['total_count'] as int?,
    json['is_booked'] as bool?,
    json['facility_name'] as String?,
  );
}

Map<String, dynamic> _$SlotToJson(Slot instance) => <String, dynamic>{
      'available_count': instance.availableCount,
      'created_at': instance.createdAt,
      'end_time': instance.endTime,
      'facility_id': instance.facilityId,
      'id': instance.id,
      'is_available': instance.isAvailable,
      'price': instance.price,
      'base_price': instance.basePrice,
      'start_time': instance.startTime,
      'updated_at': instance.updatedAt,
      'total_count': instance.totalCount,
      'is_booked': instance.isBooked,
      'facility_name': instance.facilityName,
    };

SlotGrid _$SlotGridFromJson(Map<String, dynamic> json) {
  return SlotGrid(
    (json['slot_data'] as List<dynamic>)
        .map((e) => SlotData.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['slot_timings'] as List<dynamic>)
        .map((e) => SlotTiming.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SlotGridToJson(SlotGrid instance) => <String, dynamic>{
      'slot_data': instance.slotData,
      'slot_timings': instance.slotTimings,
    };

SlotData _$SlotDataFromJson(Map<String, dynamic> json) {
  return SlotData(
    json['date'] as String,
    json['is_empty'] as bool,
    (json['slots'] as List<dynamic>)
        .map((e) => Slot.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SlotDataToJson(SlotData instance) => <String, dynamic>{
      'date': instance.date,
      'is_empty': instance.isEmpty,
      'slots': instance.slots,
    };

SlotTiming _$SlotTimingFromJson(Map<String, dynamic> json) {
  return SlotTiming(
    json['from'] as String,
    json['to'] as String,
  );
}

Map<String, dynamic> _$SlotTimingToJson(SlotTiming instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
    };

SlotMeta _$SlotMetaFromJson(Map<String, dynamic> json) {
  return SlotMeta(
    json['hasNext'] as bool,
    json['hasPrev'] as bool,
  );
}

Map<String, dynamic> _$SlotMetaToJson(SlotMeta instance) => <String, dynamic>{
      'hasNext': instance.hasNext,
      'hasPrev': instance.hasPrev,
    };

SlotsWrapper _$SlotsWrapperFromJson(Map<String, dynamic> json) {
  return SlotsWrapper(
    SlotGrid.fromJson(json['data'] as Map<String, dynamic>),
    SlotMeta.fromJson(json['meta'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SlotsWrapperToJson(SlotsWrapper instance) =>
    <String, dynamic>{
      'data': instance.slotGrid,
      'meta': instance.slotMeta,
    };
