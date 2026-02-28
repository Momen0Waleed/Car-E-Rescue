import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/create_request/view/first_page.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/create_request/view/second_page.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/create_request/view/third_page.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/create_request/view_model/create_request_view_model.dart';

class CreateRequestView extends StatefulWidget {
  const CreateRequestView({super.key});

  @override
  State<CreateRequestView> createState() => _CreateRequestViewState();
}

class _CreateRequestViewState extends State<CreateRequestView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   // Auto-request location when screen opens
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<CreateRequestViewModel>(
  //       context,
  //       listen: false,
  //     ).requestLocation();
  //   });
  // }
  @override
  void initState() {
    super.initState();
    // Ensure this is active so the GPS starts as soon as the page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CreateRequestViewModel>(
        context,
        listen: false,
      ).requestLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateRequestViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          floatingActionButton: NavigateBackButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (page) =>
                        setState(() => _currentPage = page),
                    children: [
                      FirstPage(vm: viewModel),
                      SecondPage(vm: viewModel),
                      ThirdPage(vm: viewModel),
                    ],
                  ),
                ),
                _buildNavigation(viewModel),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavigation(CreateRequestViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: AppColors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            style: ButtonStyle(
              textStyle: WidgetStateProperty.all(TextStyle(color: AppColors.red)),
            ),
            onPressed: _currentPage == 0
                ? null
                : () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  ),
            child: Text("Back"),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColors.red),
              foregroundColor: WidgetStateProperty.all(AppColors.white),
            ),
            onPressed: (vm.latitude == null || vm.isLoading)
                ? null
                : () async {
                    if (_currentPage == 0) {
                      bool apiSuccess = await vm.sendLocation();
                      if (apiSuccess) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                    } else if (_currentPage == 1) {
                      // Page 2: Check selection and finalize request
                      // Since selectedRequestType has a default value, it is always "selected"
                      bool apiSuccess = await vm.finalizeRequest();
                      if (apiSuccess) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }

                    }else if (_currentPage == 2) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        PageRoutesName.clientHome,
                            (route) => false,
                      );
                    }
                  },
            child: vm.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(_currentPage == 2 ? "Finish" : "Next"),
          ),
        ],
      ),
    );
  }
}
