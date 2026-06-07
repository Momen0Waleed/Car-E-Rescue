import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/create_request/view/first_page.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/create_request/view/second_page.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/create_request/view/third_page.dart';
import 'package:car_e_rescue/modules/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/create_request/view_model/create_request_view_model.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class CreateRequestView extends StatefulWidget {
  final bool showBackButton;
  const CreateRequestView({super.key, this.showBackButton = true});

  @override
  State<CreateRequestView> createState() => _CreateRequestViewState();
}

class _CreateRequestViewState extends State<CreateRequestView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CreateRequestViewModel>(
        context,
        listen: false,
      ).requestLocation();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateRequestViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: defaultAppBar(
            title: "New Request",
            context: context,
            showBackButton: widget.showBackButton,
          ),
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Animated Step Indicators
                _buildStepIndicators(),
                const SizedBox(height: 10),
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

  Widget _buildStepIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = _currentPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: isActive ? 24.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: isActive ? AppColors.red : AppColors.grey.withOpacity(0.35),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildNavigation(CreateRequestViewModel vm) {
    final canGoNext = vm.latitude != null && !vm.isLoading;
    final isLastStep = _currentPage == 2;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, 16, 24, widget.showBackButton ? 16 : 88),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -6),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: _currentPage == 0
                  ? AppColors.grey.withOpacity(0.5)
                  : AppColors.red,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            onPressed: _currentPage == 0
                ? null
                : () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                  ),
            child: const Text("Back"),
          ),
          Bounceable(
            scaleFactor: 0.95,
            onTap: !canGoNext
                ? null
                : () async {
                    if (_currentPage == 0) {
                      bool apiSuccess = await vm.sendLocation();
                      if (apiSuccess) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                        );
                      }
                    } else if (_currentPage == 1) {
                      bool apiSuccess = await vm.finalizeRequest();
                      if (apiSuccess) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                        );
                      }
                    } else if (isLastStep) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        PageRoutesName.clientHome,
                        (route) => false,
                      );
                    }
                  },
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: canGoNext
                    ? AppColors.red
                    : AppColors.grey.withOpacity(0.3),
                boxShadow: canGoNext
                    ? [
                        BoxShadow(
                          color: AppColors.red.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: vm.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        isLastStep ? "Finish" : "Next",
                        style: TextStyle(
                          color: canGoNext ? AppColors.white : AppColors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
