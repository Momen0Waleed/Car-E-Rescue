import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/create_request/view_model/create_request_view_model.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key,required this.vm});
  final CreateRequestViewModel vm;

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20,top: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Service Type",
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.red,width: 2),
            ),
            child: DropdownButton<String>(
              value: widget.vm.selectedRequestType,
              isExpanded: true,
              underline: const SizedBox(),
              dropdownColor: AppColors.white,
              borderRadius: BorderRadius.circular(15),
              items: widget.vm.requestTypes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,style: theme.textTheme.bodyMedium,),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) widget.vm.updateRequestType(newValue);
              },
            ),
          ),
        ],
      ),
    );
  }
}
