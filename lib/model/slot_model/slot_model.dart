class Slot {
  final int? availableCount;
  final String endTime;
  final int? facilityId;
  final String? id;
  final bool? isAvailable;
  final dynamic? price;
  final dynamic? basePrice;
  final String startTime;
  final int? totalCount;
  final bool? isBooked;
  final String? facilityName;
  final String slotDate;

  Slot({
    required this.startTime,
    required this.endTime,
    required this.slotDate,
    this.facilityId,
    this.id,
    required this.isAvailable,
    required this.price,
    this.basePrice,
    required this.totalCount,
    this.isBooked,
    this.facilityName,
    this.availableCount,
  });
}

class Timing {
  String from;
  String to;

  Timing({
    required this.from,
    required this.to,
  });
}

class SlotDate {
  final String date;
  final bool isEmpty;

  SlotDate(this.date, this.isEmpty);
}

class SlotInfo {
  final List<SlotDate> dates;
  final List<Timing> timings;
  //Info: Slot Date : List<Slots>
  final Map<String, List<Slot>> slots;

  final bool hasNext;
  final bool hasPrev;

  SlotInfo({
    required this.dates,
    required this.timings,
    required this.slots,
    required this.hasNext,
    required this.hasPrev,
  });
}
