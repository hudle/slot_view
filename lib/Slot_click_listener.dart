import 'model/slot.dart';

abstract class SlotClickListener {


  void onSlotSelected2(List<Slot> slot) {

  }
  void onNextClick();
  void onPreviousClick();
  void onInfoClick();
  void onSlotDeleted();
}
