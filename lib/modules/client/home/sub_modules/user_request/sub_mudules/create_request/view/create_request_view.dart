import 'package:car_e_rescue/modules/widgets/navigate_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/modules/client/home/sub_modules/user_request/sub_mudules/create_request/view_model/create_request_view_model.dart';

class CreateRequestView extends StatefulWidget {
  const CreateRequestView({super.key});

  @override
  State<CreateRequestView> createState() => _CreateRequestViewState();
}

class _CreateRequestViewState extends State<CreateRequestView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Auto-request location when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CreateRequestViewModel>(context, listen: false).requestLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateRequestViewModel(),
      child: Consumer<CreateRequestViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            floatingActionButton: NavigateBackButton(),
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            body: Stack(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (page) => setState(() => _currentPage = page),
                    children: [
                      _buildFirstPage(viewModel),
                      const Center(child: Text("2nd Page")),
                      const Center(child: Text("3rd Page")),
                    ],
                  ),
                ),
                Positioned(bottom: 20, left: 10, right: 10, child: _buildNavigation(viewModel)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFirstPage(CreateRequestViewModel vm) {
    return Stack(
      children: [
        FlutterMap(
          mapController: vm.mapController,
          options: MapOptions(
            initialCenter: const LatLng(30.0444, 31.2357),
            initialZoom: 13.0,
            onLongPress: (tapPosition, point) => vm.updateLocation(point), //
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // Free OSM tiles
              userAgentPackageName: 'com.example.car_e_rescue',
            ),
            if (vm.latitude != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(vm.latitude!, vm.longitude!),
                    width: 80,
                    height: 80,
                    child: const Icon(Icons.location_on, color: Colors.red, size: 45),
                  ),
                ],
              ),
          ],
        ),

        Positioned(
          bottom: 160,
          right: 20,
          width: 50,
          height: 50,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: AppColors.red,
            onPressed: vm.requestLocation,
            child: vm.isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.my_location, color: Colors.white),
          ),
        ),

        Positioned(
          bottom: 100,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              vm.latitude == null
                  ? "Long press to pick location"
                  : "Selected: ${vm.latitude!.toStringAsFixed(4)}, ${vm.longitude!.toStringAsFixed(4)}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigation(CreateRequestViewModel vm) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: AppColors.white
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: _currentPage == 0 ? null : () => _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
            child: const Text("Back"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: (vm.latitude == null)
                ? null
                : () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
            child: Text(_currentPage == 2 ? "Finish" : "Next", style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}