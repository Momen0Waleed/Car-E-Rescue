import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'client_home_view.dart';
import '../sub_modules/user_diagnose/view/user_diagnose_view.dart';
import '../sub_modules/user_request/sub_mudules/create_request/view/create_request_view.dart';
import '../sub_modules/user_profile/view/client_profile_view.dart';

class ClientMainView extends StatefulWidget {
  const ClientMainView({super.key});

  @override
  State<ClientMainView> createState() => _ClientMainViewState();
}

class _ClientMainViewState extends State<ClientMainView> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      ClientHomeView(),
      const UserDiagnoseView(showBackButton: false),
      const CreateRequestView(showBackButton: false),
      ClientProfileView(showBackButton: false),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildFloatingBottomBar(),
    );
  }

  Widget _buildFloatingBottomBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.grey.withOpacity(0.12),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem(
            index: 0,
            icon: Icons.home_rounded,
            inactiveIcon: Icons.home_outlined,
            label: "Home",
          ),
          _buildTabItem(
            index: 1,
            icon: Icons.analytics_rounded,
            inactiveIcon: Icons.analytics_outlined,
            label: "Diagnose",
          ),
          _buildCentralAddButton(),
          _buildTabItem(
            index: 3,
            icon: Icons.person_rounded,
            inactiveIcon: Icons.person_outline_rounded,
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required IconData icon,
    required IconData inactiveIcon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: Bounceable(
        scaleFactor: 0.85,
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.red.withOpacity(0.08) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isSelected ? icon : inactiveIcon,
                color: isSelected ? AppColors.red : AppColors.grey.withOpacity(0.8),
                size: 24,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppColors.red : AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCentralAddButton() {
    final isSelected = _currentIndex == 2;
    return Bounceable(
      scaleFactor: 0.9,
      onTap: () {
        setState(() {
          _currentIndex = 2;
        });
      },
      child: Transform.translate(
        offset: const Offset(0, -12),
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSelected
                  ? [AppColors.red, const Color(0xFF9E1F1E)]
                  : [AppColors.red, AppColors.red.withOpacity(0.85)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.red.withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 6),
                spreadRadius: 1,
              ),
            ],
            border: Border.all(
              color: AppColors.white,
              width: 3.5,
            ),
          ),
          child: const Icon(
            Icons.add_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}
