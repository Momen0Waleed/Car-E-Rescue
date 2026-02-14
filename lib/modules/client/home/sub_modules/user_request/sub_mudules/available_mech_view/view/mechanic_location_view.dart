import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/available_mech_view/model/mechanic_data_model.dart';
import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
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

  // Fetch user location from local storage (set during the FirstPage step)
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
                    height: 80,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [const BoxShadow(color: Colors.black26, blurRadius: 4)],
                          ),
                          child: Text(
                            widget.mechanic.workshopName,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.build, color: Colors.red, size: 40),
                      ],
                    ),
                  ),
                  // --- User Marker ---
                  if (userLocation != null)
                    Marker(
                      point: userLocation!,
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.person_pin_circle,
                        color: Colors.blue,
                        size: 45,
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 50,
            left: 10,
            child: const NavigateBackButton(),
          ),

          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // User Location
                FloatingActionButton(
                  heroTag: "user_loc",
                  onPressed: _moveToUser,
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(height: 12),
                // Mechanic Location
                FloatingActionButton(
                  heroTag: "mech_loc",
                  onPressed: _moveToMechanic,
                  backgroundColor: AppColors.red,
                  child: const Icon(Icons.build, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}