import 'package:car_e_rescue/core/constants/images/images_dir.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/auth/user_type/view_model/user_type_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:provider/provider.dart';

class SelectedUserWidget extends StatefulWidget {
  const SelectedUserWidget({super.key});

  @override
  State<SelectedUserWidget> createState() => _SelectedUserWidgetState();
}

class _SelectedUserWidgetState extends State<SelectedUserWidget> {
  @override
  Widget build(BuildContext context) {
  var theme = Theme.of(context);
  var provider = Provider.of<UserTypeViewModel>(context);

    return Row(
      children: [
        Expanded(
          child: Bounceable(
            onTap: () {
              provider.changeUser(true);
            },
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: provider.setSelectedContainerColor(),
                borderRadius: BorderRadius.circular(16),
                border: BoxBorder.all(width: 1, color: AppColors.red),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 12,
                  children: [
                    Image.asset(
                      ImagesDir.clientIcon,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                      color: provider.setUnSelectedContainerColor(),
                    ),
                    Text(
                      "Client",
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: provider.setUnSelectedContainerColor(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 30),
        Expanded(
          child: Bounceable(
            onTap: () {
              /// Set the selected User as Provider
              provider.changeUser(false);
            },
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: provider.setUnSelectedContainerColor(),
                borderRadius: BorderRadius.circular(16),
                border: BoxBorder.all(width: 1, color: AppColors.red),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 12,
                  children: [
                    Image.asset(
                      ImagesDir.mechanicIcon,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                      color: provider.setSelectedContainerColor(),
                    ),
                    Text(
                      "Provider",
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: provider.setSelectedContainerColor(),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
