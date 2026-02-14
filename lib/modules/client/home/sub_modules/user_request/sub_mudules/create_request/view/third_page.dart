import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/create_request/view_model/create_request_view_model.dart';
import 'package:car_e_rescue/modules/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key,required this.vm});
  final CreateRequestViewModel vm;

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20,top: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.hourglass_empty, color: Colors.orange, size: 60),
          const SizedBox(height: 20),
          Text(
            widget.vm.requestStatus ?? "Request Submitted",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          CustomButton(
            width: MediaQuery.of(context).size.width / 1.5,
            action: () => Navigator.of(
              context,
            ).pushReplacementNamed(PageRoutesName.clientCurrentRequest),
            text: "Track your Request",
            color: AppColors.red,
          ),
        ],
      ),
    );
  }
}
