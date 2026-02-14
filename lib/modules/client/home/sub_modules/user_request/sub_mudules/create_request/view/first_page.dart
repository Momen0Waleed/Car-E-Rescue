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
        FlutterMap(
          mapController: widget.vm.mapController,
          options: MapOptions(
            initialCenter: const LatLng(30.0444, 31.2357),
            initialZoom: 13.0,
            onLongPress: (tapPosition, point) =>
                widget.vm.updateLocation(point), //
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // Free OSM tiles
              userAgentPackageName: 'com.example.car_e_rescue',
            ),
            if (widget.vm.latitude != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(widget.vm.latitude!, widget.vm.longitude!),
                    width: 80,
                    height: 80,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 45,
                    ),
                  ),
                ],
              ),
          ],
        ),

        Positioned(
          bottom: 80,
          right: 20,
          width: 50,
          height: 50,
          child: FloatingActionButton(
            heroTag: "gps_fab",
            mini: true,
            backgroundColor: AppColors.red,
            onPressed: widget.vm.requestLocation,
            child: widget.vm.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.my_location, color: Colors.white),
          ),
        ),

        Positioned(
          bottom: 10,
          left: 20,
          right: 20,
          height: 50,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.vm.isSuccess) ...[
                  const Icon(Icons.check_circle, color: Colors.green, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    "Location Verified",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ]
                else if (widget.vm.latitude != null) ...[
                  const Icon(
                    Icons.task_alt_rounded,
                    color: Colors.blue,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Location Ready",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ] else
                  const Text(
                    "Long press to pick location",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
