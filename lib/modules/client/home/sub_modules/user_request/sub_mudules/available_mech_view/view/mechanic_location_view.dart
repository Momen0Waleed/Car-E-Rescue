import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/available_mech_view/model/mechanic_data_model.dart';
import 'package:car_e_rescue/modules/client/home/view/widgets/client_navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MechanicLocationView extends StatefulWidget {
  final MechanicDataModel mechanic;
  const MechanicLocationView({super.key, required this.mechanic});

  @override
  State<MechanicLocationView> createState() => _MechanicLocationViewState();
}

class _MechanicLocationViewState extends State<MechanicLocationView> {
  final MapController _mapController = MapController();
  LatLng? userLocation;

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  Future<void> _loadUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble('user_lat');
    final lng = prefs.getDouble('user_lng');
    if (lat != null && lng != null) {
      setState(() {
        userLocation = LatLng(lat, lng);
      });
    }
  }

  void _moveToMechanic() {
    _mapController.move(
      LatLng(widget.mechanic.workshopLat, widget.mechanic.workshopLng),
      15.0,
    );
  }

  void _moveToUser() {
    if (userLocation != null) {
      _mapController.move(userLocation!, 15.0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User location not found")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mechanicLocation = LatLng(
      widget.mechanic.workshopLat,
      widget.mechanic.workshopLng,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: mechanicLocation,
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.car_e_rescue',
              ),
              MarkerLayer(
                markers: [
                  // --- Mechanic Marker ---
                  Marker(
                    point: mechanicLocation,
                    width: 150,
                    height: 90,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ],
                            border: Border.all(color: AppColors.red.withOpacity(0.1), width: 1),
                          ),
                          child: Text(
                            widget.mechanic.workshopName,
                            style: TextStyle(
                              fontSize: 11, 
                              fontWeight: FontWeight.w800,
                              color: AppColors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Icon(
                          Icons.build_circle_rounded, 
                          color: AppColors.red, 
                          size: 38,
                          shadows: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // --- User Marker ---
                  if (userLocation != null)
                    Marker(
                      point: userLocation!,
                      width: 80,
                      height: 80,
                      child: Icon(
                        Icons.person_pin_circle_rounded,
                        color: Colors.blue,
                        size: 45,
                        shadows: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
          
          Positioned(
            top: 50,
            left: 10,
            child: const ClientNavigateBackButton(),
          ),

          // Custom control overlays at bottom-right
          Positioned(
            bottom: 30,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // User Location center button
                FloatingActionButton(
                  heroTag: "user_loc",
                  onPressed: _moveToUser,
                  mini: true,
                  backgroundColor: Colors.blue,
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.person_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(height: 12),
                // Mechanic Location center button
                FloatingActionButton(
                  heroTag: "mech_loc",
                  onPressed: _moveToMechanic,
                  backgroundColor: AppColors.red,
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.build_rounded, color: Colors.white, size: 22),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}