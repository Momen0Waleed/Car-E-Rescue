import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/mechanic/home/sub_modules/available_requests/model/available_request_model.dart';
import 'package:car_e_rescue/modules/mechanic/home/sub_modules/available_requests/view_model/mechanic_available_requests_view_model.dart';
import 'package:car_e_rescue/modules/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class RequestDetailsView extends StatefulWidget {
  final AvailableRequestModel request;

  const RequestDetailsView({super.key, required this.request});

  @override
  State<RequestDetailsView> createState() => _RequestDetailsViewState();
}

class _RequestDetailsViewState extends State<RequestDetailsView> {
  @override
  void initState() {
    super.initState();
    // Triggers the initial fetch when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MechanicAvailableRequestsViewModel>().getRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final LatLng requestLocation = LatLng(widget.request.lat, widget.request.lng);

    return Consumer<MechanicAvailableRequestsViewModel>(
      builder: (context, vm, child) {
        return Scaffold(
          appBar: defaultAppBar(title: "Request Details", context: context),
          body: Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: requestLocation,
                  initialZoom: 15.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.car_e_rescue',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: requestLocation,
                        width: 80,
                        height: 80,
                        child: Icon(
                            Icons.location_on,
                            color: AppColors.red,
                            size: 45
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Positioned(
                bottom: 20,
                left: 15,
                right: 15,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            widget.request.userName,
                            style: Theme.of(context).textTheme.headlineSmall
                        ),
                        const Divider(),
                        const SizedBox(height: 5),
                        Text("Service Type: ${widget.request.type}"),
                        Text(
                            "Distance: ${widget.request.distance.toStringAsFixed(2)} km"
                        ),
                        const SizedBox(height: 20),

                        // Accept Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.red,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: vm.isAccepting
                                ? null
                                : () async {
                              bool success = await vm.acceptRequest(widget.request.requestId);
                              if (success && context.mounted) {
                                Navigator.pop(context);
                                vm.getRequests(showLoading: false);
                              }
                            },
                            child: vm.isAccepting
                                ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.red,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text(
                              "Accept Request",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        )
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