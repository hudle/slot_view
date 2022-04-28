// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hudle_core/hudle_core.dart';
import 'package:hudle_theme/hudle_theme.dart';

// Project imports:
import '../common/gap_widget.dart';

class DateItem extends StatelessWidget {
  const DateItem({Key? key, this.date = "24", this.day = "Mon", this.onDateTap})
      : super(key: key);

  final String date;
  final String day;

  final VoidCallback? onDateTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onDateTap,
      child: Container(
        child: Column(
          children: [
            NormalText(
              date,
              color: kSecondaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            VerticalGap(
              gap: 2,
            ),
            NormalText(
              day,
              color: kSecondaryText,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            )
          ],
        ),
      ),
    );
  }
}
