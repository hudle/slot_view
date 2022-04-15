import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'model/slot.dart';


class SlotViewController extends GetxController {
  final List<SlotData> data;
  final selected = <String,Set<Slot>>{}.obs;


  int get slotDataLength => data.length;
  SlotViewController(this.data);

  void setSelection(Slot slot,String date) {

    if(slot.isAvailable ==null || slot.isAvailable == false)
    {
      return;
    }
    if(isSelected(slot, date)) {
      selected[date]?.remove(slot);
    }
    else{
      if(selected[date] == null)
      {
        selected[date]= {slot};
      }
      else
      {
        selected[date]?.add(slot);
      }
    }

    selected.refresh();

  }

  void setSelections(List<Slot> slots,String date) {

    if(selected[date] == null)
    {
      selected[date] = slots.toSet();
    }
    else
    {
      if(selected[date]!.containsAll(slots))
      {
        selected[date]!.clear();
      }
      else {
        selected[date]!.addAll(slots);
      }

    }
    print(' selected length :${selected[date]!.length}');

    selected.refresh();


  }

  bool  isSelected(slot,String date) {
    return selected[date]?.contains(slot)??false;
  }

  List<Slot> getAllSlots()
  {
    List<Slot> newList = [];
    selected.forEach((key, value) {
      newList.addAll(value);
    });

    return newList;
  }

}
