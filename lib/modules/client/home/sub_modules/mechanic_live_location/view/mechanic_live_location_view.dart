// mechanic_live_location_view.dart
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:car_e_rescue/modules/client/home/view/widgets/client_navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import '../view_model/mechanic_live_location_view_model.dart';

class MechanicLiveLocationView extends StatefulWidget {
  final int requestId;
  const MechanicLiveLocationView({super.key, required this.requestId});

  @override
  State<MechanicLiveLocationView> createState() => _MechanicLiveLocationViewState();
}

class _MechanicLiveLocationViewState extends State<MechanicLiveLocationView> with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  late MechanicLiveLocationViewModel _vm;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _vm = context.read<MechanicLiveLocationViewModel>();
    _vm.addListener(_onLocationUpdate);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _vm.initTracking(widget.requestId);
    });
  }

  bool _hasNavigatedToRating = false;

  void _onLocationUpdate() {
    if (_vm.mechanicLocation != null) {
      try {
        _mapController.move(_vm.mechanicLocation!, _mapController.camera.zoom);
      } catch (_) {}
    }
    
    if (_vm.hasArrived && !_hasNavigatedToRating) {
      _hasNavigatedToRating = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(
            PageRoutesName.clientRating,
            arguments: widget.requestId,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _vm.removeListener(_onLocationUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MechanicLiveLocationViewModel>(
      builder: (context, vm, child) {
        if (vm.isError) {
          return const Scaffold(
            body: Center(
              child: Text("Failed to connect to tracker. Please try again."),
            ),
          );
        }

        if (vm.mechanicLocation == null) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.red),
            ),
          );
        }

        final isArrived = vm.mechanicStatus == "Arrived";

        return Scaffold(
          floatingActionButton: const ClientNavigateBackButton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          body: Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: vm.mechanicLocation!,
                  initialZoom: 15.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.car_e_rescue',
                  ),
                  MarkerLayer(
                    markers: [
                      if (vm.userLocation != null)
                        Marker(
                          point: vm.userLocation!,
                          width: 60,
                          height: 60,
                          child: Icon(
                            Icons.person_pin_circle_rounded,
                            color: AppColors.red,
                            size: 44,
                            shadows: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                        ),
                      if (vm.mechanicLocation != null)
                        Marker(
                          point: vm.mechanicLocation!,
                          width: 60,
                          height: 60,
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Center(
                                child: Container(
                                  width: 44 + (10 * _animationController.value),
                                  height: 44 + (10 * _animationController.value),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue.withOpacity(0.2),
                                  ),
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                    ),
                                    child: const Icon(
                                      Icons.build_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              
              // Premium Status card at the bottom
              Positioned(
                bottom: 30,
                left: 20,
                right: 20,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                  builder: (context, val, childWidget) {
                    return Opacity(
                      opacity: val,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - val)),
                        child: childWidget,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(color: AppColors.grey.withOpacity(0.1), width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: (isArrived ? AppColors.green : AppColors.red).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isArrived ? Icons.check_circle_rounded : Icons.directions_car_rounded,
                            color: isArrived ? AppColors.green : AppColors.red,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "RESCUE STATUS",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.grey,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                vm.mechanicStatus,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: isArrived ? AppColors.green : AppColors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isArrived) ...[
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}