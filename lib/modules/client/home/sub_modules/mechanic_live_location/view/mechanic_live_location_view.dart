// mechanic_live_location_view.dart
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
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

class _MechanicLiveLocationViewState extends State<MechanicLiveLocationView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MechanicLiveLocationViewModel>().initTracking(widget.requestId);
    });
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
          appBar: AppBar(title: Text(vm.hasArrived ? "Mechanic Arrived" : "Tracking Mechanic")),
          body: FlutterMap(
            options: MapOptions(
              initialCenter: vm.mechanicLocation!,
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
              MarkerLayer(
                markers: [
                  Marker(
                    point: vm.mechanicLocation!,
                    child: const Icon(Icons.build, color: Colors.blue, size: 40),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}