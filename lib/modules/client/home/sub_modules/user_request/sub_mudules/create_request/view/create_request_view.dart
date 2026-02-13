import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/create_request/view/first_page.dart';
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateRequestViewModel()..requestLocation(),
      child: Consumer<CreateRequestViewModel>(
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
                        const Center(child: Text("2nd Page")),
                        const Center(child: Text("3rd Page")),
                      ],
                    ),
                  ),
                  _buildNavigation(viewModel),
                ],
              ),
            ),
          );
        },
      ),
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
            onPressed: _currentPage == 0
                ? null
                : () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  ),
            child: const Text("Back"),
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
                    }
                  },
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }
}
