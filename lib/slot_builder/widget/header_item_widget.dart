// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hudle_core/hudle_core.dart';
import 'package:hudle_theme/hudle_theme.dart';

// Project imports:
import '../../common/gap_widget.dart';


class HeaderItem extends StatelessWidget {
  const HeaderItem({Key? key, required this.title, required this.subtitle, this.onTap})
      : super(key: key);

  final String title;
  final String subtitle;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          NormalText(
            title,
            color: kSecondaryText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          VerticalGap(
            gap: 2,
          ),
          NormalText(
            subtitle,
            color: kSecondaryText,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          )
        ],
      ),
    );
  }
}
