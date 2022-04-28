// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hudle_core/hudle_core.dart';
import 'package:hudle_theme/hudle_theme.dart';

// Project imports:
import 'gap_widget.dart';

class LegendView extends StatelessWidget {
  Widget legendItem(Color color, Color border, String text) => Row(
        children: [
          Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
                color: color,
                border: Border.all(
                  color: border,
                  width: 1,
                )),
          ),
          HorizontalGap(),
          NormalText(text.toUpperCase(), fontSize: 10)
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: kColorLegendBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          legendItem(kColorAccent, kColorAccent, "Booked"),
          legendItem(kColorWhite, kColorGrey500, "Available"),
          legendItem(kColorLegendNotAvailable, kColorGrey500, "Not Available"),
          legendItem(kColorLegendSelected, kColorPrimary, "Selected"),
        ],
      ),
    );
  }
}
