// mechanic_live_location_view.dart
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
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
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _vm = context.read<MechanicLiveLocationViewModel>();
    
    _vm.addListener(_onLocationUpdate);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _vm.initTracking(widget.requestId);
    });
  }

  void _onLocationUpdate() {
    if (_vm.mechanicLocation != null) {
      try {
        _mapController.move(_vm.mechanicLocation!, _mapController.camera.zoom);
      } catch (_) {
        // Map not fully initialized yet, it's fine.
      }
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
          return Scaffold(
            body: Center(
              child: Text("Failed to connect to tracker. Please try again."),
            ),
          );
        }

        if (vm.mechanicLocation == null) {
          return Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.red,)));
        }

        return Scaffold(
          floatingActionButton: const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: NavigateBackButton(),
          ),
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
                          child: const Icon(Icons.person_pin_circle, color: Colors.red, size: 40),
                        ),
                      if (vm.mechanicLocation != null)
                        Marker(
                          point: vm.mechanicLocation!,
                          child: FadeTransition(
                            opacity: _animationController,
                            child: const Icon(Icons.build, color: Colors.blue, size: 40),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              Positioned(
                bottom: 30,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      vm.mechanicStatus == "Arrived"
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 30,
                            )
                          : Icon(
                              Icons.hourglass_empty,
                              color: AppColors.red,
                              size: 30,
                            ),
                      const SizedBox(width: 15),
                      Text(
                        vm.mechanicStatus,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: vm.mechanicStatus == "Arrived" ? Colors.green : AppColors.red,
                        ),
                      ),
                    ],
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