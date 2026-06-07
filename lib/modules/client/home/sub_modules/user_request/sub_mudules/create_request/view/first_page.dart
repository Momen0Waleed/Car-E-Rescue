import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/create_request/view_model/create_request_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key, required this.vm});
  final CreateRequestViewModel vm;
  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map Canvas
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: FlutterMap(
            mapController: widget.vm.mapController,
            options: MapOptions(
              initialCenter: const LatLng(30.0444, 31.2357),
              initialZoom: 13.0,
              onLongPress: (tapPosition, point) =>
                  widget.vm.updateLocation(point),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.car_e_rescue',
              ),
              if (widget.vm.latitude != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(widget.vm.latitude!, widget.vm.longitude!),
                      width: 80,
                      height: 80,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.red.withOpacity(0.15),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.location_on_rounded,
                          color: AppColors.red,
                          size: 44,
                          shadows: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),

        // Floating GPS FAB with entry transition
        Positioned(
          bottom: 90,
          right: 20,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
            builder: (context, val, child) {
              return Transform.scale(
                scale: val,
                child: child,
              );
            },
            child: FloatingActionButton(
              heroTag: "gps_fab",
              backgroundColor: AppColors.red,
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              onPressed: widget.vm.requestLocation,
              child: widget.vm.isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Icon(Icons.my_location_rounded, color: Colors.white, size: 24),
            ),
          ),
        ),

        // Bottom status card panel with slide-up transition
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          height: 54,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 40.0, end: 0.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, val, child) {
              return Transform.translate(
                offset: Offset(0, val),
                child: Opacity(
                  opacity: (40.0 - val) / 40.0,
                  child: child,
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(color: AppColors.grey.withOpacity(0.08), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.vm.isSuccess) ...[
                    const Icon(Icons.check_circle_rounded, color: Colors.green, size: 22),
                    const SizedBox(width: 8),
                    const Text(
                      "Location Verified",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 14,
                      ),
                    ),
                  ]
                  else if (widget.vm.latitude != null) ...[
                    const Icon(
                      Icons.task_alt_rounded,
                      color: Colors.blue,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Location Ready",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                    ),
                  ] else ...[
                    Icon(Icons.touch_app_rounded, color: AppColors.grey, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Long press map to set location",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.black.withOpacity(0.7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

