import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

PreferredSizeWidget? defaultAppBar({
  required String title,
  required BuildContext context,
  bool showBackButton = true,
}) {
  return AppBar(
    centerTitle: true,
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
    ),
    automaticallyImplyLeading: showBackButton,
    leading: showBackButton
        ? Center(
            child: Bounceable(
              scaleFactor: 0.9,
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                      spreadRadius: 1,
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.grey.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFFC32B2A), // AppColors.red
                    size: 16,
                  ),
                ),
              ),
            ),
          )
        : null,
    leadingWidth: showBackButton ? 60 : 0,
  );
}
