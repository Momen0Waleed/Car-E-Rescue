import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/mechanic/home/sub_modules/workshop_location/view_model/workshop_location_view_model.dart';
import 'package:car_e_rescue/modules/widgets/default_app_bar.dart';
import 'package:car_e_rescue/modules/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class WorkshopLocationView extends StatelessWidget {
  const WorkshopLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorkshopLocationViewModel(),
      child: Scaffold(
        appBar: defaultAppBar(title: "Workshop Location", context: context),
        body: Consumer<WorkshopLocationViewModel>(
          builder: (context, vm, child) {
            return Stack(
              children: [
                FlutterMap(
                  mapController: vm.mapController,
                  options: MapOptions(
                    initialCenter: const LatLng(30.0444, 31.2357),
                    initialZoom: 13.0,
                    onLongPress: (tapPosition, point) => vm.updateLocation(point),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.car_e_rescue',
                    ),
                    if (vm.latitude != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(vm.latitude!, vm.longitude!),
                            width: 80, height: 80,
                            child: Icon(Icons.store, color: AppColors.red, size: 45),
                          ),
                        ],
                      ),
                  ],
                ),
                // GPS FAB
                Positioned(
                  bottom: 140, right: 20,
                  child: FloatingActionButton(
                    heroTag: "workshop_gps_fab",
                    backgroundColor: AppColors.red,
                    onPressed: vm.requestLocation,
                    child: vm.isLoading
                        ? CircularProgressIndicator(color: AppColors.white)
                        : Icon(Icons.my_location, color: AppColors.white),
                  ),
                ),
                // Confirm Button
                Positioned(
                  bottom: 40, left: 20, right: 20,
                  child: CustomButton(
                    text: "Confirm Workshop Location",
                    color: AppColors.red,
                    action: () async {
                      bool success = await vm.saveLocation();
                      if (success) {
                        Navigator.pop(context, true);
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}