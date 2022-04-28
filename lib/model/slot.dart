// Package imports:
import 'package:json_annotation/json_annotation.dart';

// Project imports:
import '../common/date_time_utils.dart';

part 'slot.g.dart';

@Deprecated("Use Slot Model for Grid view")
@JsonSerializable()
class Slot {
  @JsonKey(name: "available_count")
  final int? availableCount;
  // @JsonKey(name: "bookings")
  // List<Booking>? bookings;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "end_time")
  final String endTime;
  @JsonKey(name: "facility_id")
  final int? facilityId;
  @JsonKey(name: "id")
  final String? id;
  @JsonKey(name: "is_available")
  final bool? isAvailable;
  @JsonKey(name: "price")
  final dynamic? price;
  @JsonKey(name: "base_price")
  final dynamic? basePrice;
  @JsonKey(name: "start_time")
  final String startTime;
  @JsonKey(name: "updated_at")
  final String? updatedAt;
  @JsonKey(name: "total_count")
  final int? totalCount;
  @JsonKey(name: "is_booked")
  final bool? isBooked;
  @JsonKey(name: "facility_name")
  final String? facilityName;

  Slot(
    this.availableCount,
    // this.bookings,
    this.createdAt,
    this.endTime,
    this.facilityId,
    this.id,
    this.isAvailable,
    this.price,
    this.basePrice,
    this.startTime,
    this.updatedAt,
    this.totalCount,
    this.isBooked,
    this.facilityName,
  );

  factory Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);

  Map<String, dynamic> toJson() => _$SlotToJson(this);

  SlotStatus get slotStatus {
    if (isAvailable == true &&
        (availableCount ?? 0) > 0 &&
        minusLeft(endTime) >= 0) {
      return SlotStatus.AVAILABLE;
    } else if (isAvailable == true && (availableCount ?? 0) <= 0) {
      return SlotStatus.BOOKED;
    } else
      return SlotStatus.NOT_AVAILABLE;
  }
}

@JsonSerializable()
class SlotGrid {
  @JsonKey(name: 'slot_data')
  final List<SlotData> slotData;

  @JsonKey(name: 'slot_timings')
  final List<SlotTiming> slotTimings;

  SlotGrid(this.slotData, this.slotTimings);

  factory SlotGrid.fromJson(Map<String, dynamic> json) =>
      _$SlotGridFromJson(json);

  Map<String, dynamic> toJson() => toMap(this); //_$SlotGridToJson(this);

  Map<String, dynamic> toMap(SlotGrid instance) => <String, dynamic>{
        'slot_data': instance.slotData.map((e) => e.toJson()).toList(),
        'slot_timings': instance.slotTimings.map((e) => e.toJson()).toList(),
      };
}

@JsonSerializable()
class SlotData {
  @JsonKey(name: 'date')
  final String date;

  @JsonKey(name: 'is_empty')
  final bool isEmpty;

  @JsonKey(name: 'slots')
  final List<Slot> slots;

  SlotData(this.date, this.isEmpty, this.slots);

  factory SlotData.fromJson(Map<String, dynamic> json) =>
      _$SlotDataFromJson(json);

  Map<String, dynamic> toJson() => toMap(this);

  Map<String, dynamic> toMap(SlotData instance) => <String, dynamic>{
        'date': instance.date,
        'is_empty': instance.isEmpty,
        'slots': instance.slots.map((e) => e.toJson()).toList(),
      };
}

@JsonSerializable()
class SlotTiming {
  @JsonKey(name: 'from')
  String from;

  @JsonKey(name: 'to')
  String to;

  SlotTiming(this.from, this.to);

  factory SlotTiming.fromJson(Map<String, dynamic> json) =>
      _$SlotTimingFromJson(json);

  Map<String, dynamic> toJson() => _$SlotTimingToJson(this);
}

@JsonSerializable()
class SlotMeta {
  @JsonKey(name: 'hasNext')
  final bool hasNext;

  @JsonKey(name: 'hasPrev')
  final bool hasPrev;

  SlotMeta(this.hasNext, this.hasPrev);

  factory SlotMeta.fromJson(Map<String, dynamic> json) =>
      _$SlotMetaFromJson(json);

  Map<String, dynamic> toJson() => _$SlotMetaToJson(this);
}

@JsonSerializable()
class SlotsWrapper {
  @JsonKey(name: "data")
  final SlotGrid slotGrid;

  @JsonKey(name: "meta")
  final SlotMeta slotMeta;

  SlotsWrapper(this.slotGrid, this.slotMeta);

  factory SlotsWrapper.fromJson(Map<String, dynamic> json) =>
      _$SlotsWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$SlotsWrapperToJson(this);

  Map<String, dynamic> toMap() => <String, dynamic>{
        'data': slotGrid.toJson(),
        'meta': slotMeta.toJson(),
      };
}

enum SlotStatus { BOOKED, NOT_AVAILABLE, AVAILABLE }
