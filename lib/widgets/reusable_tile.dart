import 'package:flutter/material.dart';

import '../app theme/app_colors.dart';
import '../app theme/text_style.dart';



class ReusableTile extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final VoidCallback? onTap;

  const ReusableTile({
    super.key,
    this.title,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: AppColors.primaryWhite,
        child: ListTile(
          leading: Icon(
            icon,
            size: 30,
            color: AppColors.primaryBlack,
          ),
          title: Text(
            title!,
            style: AppStyle.heading2,
          ),
        ),
      ),
    );
  }
}
