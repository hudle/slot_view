// Project imports:
import 'package:hudle_slots_view/model/slot_model/slot_model.dart';

abstract class SlotClickListener {
  void onSlotSelected2(List<Slot> slot) {}
  void onNextClick();
  void onPreviousClick();
  void onInfoClick();
  void onSlotDeleted();
}
